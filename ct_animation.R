exif_out<-read.table("D:/Fiona/Biome_Health_Project/exif_output/exif_out.txt", fill = NA, sep = ",", stringsAsFactors = FALSE)
colnames(exif_out)<-c("site", "folder", "subfolder", "IMG_no", "Camera_brand", "Camera_model", "datetime", "Light_source", "Flash")

bad_files<-exif_out[grepl("Bad file", exif_out$site),]


exif_out<-exif_out[!grepl("Bad file", exif_out$site),]

#get rid of files in corrupted_exif folder


exif_out<-exif_out[!grepl("corrupted_exif", exif_out$site),]


btcf<-exif_out[grepl("101_BTCF", exif_out$subfolder),]



library(dplyr)
library(stringr)

exif_out<-exif_out %>%
  mutate(subfolder=replace(subfolder, subfolder==" 100_BTCF", "MN37_CT140"),subfolder=replace(subfolder, subfolder==" 101_BTCF", "MN37_CT140")) %>%
  as.data.frame()

exif_out$Location.ID <- vapply(strsplit(exif_out$subfolder,"_"), `[`, 1, FUN.VALUE=character(1))

exif_out$Location.ID<-str_trim(exif_out$Location.ID)


locs<-read.csv("CameraLocations.csv", stringsAsFactors = FALSE)

exif_locs<-merge(locs, exif_out, by = "Location.ID")



#####animation
library(lubridate)

exif_locs$datetime<-as.POSIXct(exif_locs$datetime, format = "%Y:%m:%d %H:%M:%S", tz = "UTC")

exif_locs$date<-as.Date(exif_locs$datetime, "%Y:%m:%d", tz = "UTC")


exif_daily<-exif_locs %>% 
  group_by(Location.ID,Latitude, Longitude, date) %>% 
  tally()


###################

library(tidyverse) # dev ggplot version required: devtools::install_github("hadley/ggplot2")
library(readxl)
library(httr)
library(ggmap)
library(gganimate)
library(gifski)
library(dplyr)
library(sf)


URL <- "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_map_units.zip"
temp <- tempfile()
download.file(URL, temp)
unzip(temp)
unlink(temp)


world <- st_read("ne_110m_admin_0_map_units.shp") %>% 
  st_transform(crs = "+proj=longlat +datum=WGS84") %>% 
  filter(!NAME_EN %in% c("Fr. S. Antarctic Lands", "Antarctica"))

kenya<-world <- st_read("ne_110m_admin_0_map_units.shp") %>% 
  st_transform(crs = "+proj=longlat +datum=WGS84") %>% 
  filter(NAME_EN %in% c("Kenya"))



kenya<- st_read("D:/Fiona/Biome_Health_Project/ke_protected-areas.shp") %>% 
  st_transform(crs = "+proj=longlat +datum=WGS84") %>% 
  filter(NAME %in% c("Masai Mara NR"))


wdpa_fetch(id = 1297, type = "csv")


projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
df <- st_as_sf(x = exif_daily,                         
               coords = c("Longitude", "Latitude"),
               crs = projcrs)

ggplot() +
  geom_sf(data = kenya, colour = "#ffffff20", fill = "#2d2d2d60", size = .5)+
  geom_sf(data = df, aes(size = n))+
  coord_equal()+
  transition_time(date)+
  ease_aes('linear')



