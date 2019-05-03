library(here)

#exif_out<-read.table(here("/exif_output/exif_out_new.txt"), fill = NA, sep = ",", stringsAsFactors = FALSE)

#files_moved<-list.files("M:/biome_health_project_files/country_files/kenya/working_data/", recursive = TRUE, full.names = TRUE)

# saveRDS(files_moved, "list_files_RDS_working.rds")

exif_out<-readRDS("list_files_RDS_working.rds")

# colnames(exif_out)<-c("filepath", "Camera_brand", "Camera_model", "datetime","datetime_digitized", "Light_source", "Flash")
# 
# bad_files<-exif_out[grepl("Bad file", exif_out$filepath),]
# 
# exif_out<-exif_out[!grepl("Bad file", exif_out$filepath),]


#get rid of files in corrupted_exif folder

exif_out<-exif_out[grepl(".JPG", exif_out)]


###Getting image number out of filepath
file_split<-strsplit(exif_out, "/")

get_last<-function(x){
  image_out<-x[[length(x)]]
  return(image_out)
}

image_nos<-lapply(file_split, get_last)
img_nos<-unlist(image_nos)


exif_out<-data.frame(exif_out, img_nos)
colnames(exif_out)<-c("filepath", "image_no")

exif_out$image_num<-as.numeric(gsub("[^0-9]", "",exif_out$image_no))


##Getting the site and camera id for each image

get_second_last<-function(x){
  image_out<-x[[(length(x)-1)]]
  if(grepl("BTCF",image_out)){
    image_out<-x[[(length(x)-2)]]
  }
  
  #image_out<-strsplit(image_out, "_")[[1]][1]
  
  return(image_out)
}


site_cam<-lapply(file_split, get_second_last)
site_cam<-unlist(site_cam)

exif_out$site_cam<-site_cam


library(stringr)

#last character in camera string
ab<-str_sub(exif_out$site_cam,-1,-1)

# Check that it doesn't match any non-letter
letters_only <- function(x) !grepl("[^A-Za-z]", x)

# Check that it doesn't match any non-number
numbers_only <- function(x) !grepl("\\D", x)


ab[numbers_only(ab)]<-"a"


ab[ab == "A"]<-"a"
ab[ab == "B"]<-"b"

table(ab)

exif_out$ab<-ab


exif_out$month<-ifelse(grepl("november",exif_out$filepath), "november", "october")

exif_out$new_img_num<-exif_out$image_num

exif_out$new_img_num[exif_out$month == "november"]<-exif_out$image_num[exif_out$month == "november"]+20000

exif_out$new_img_num[exif_out$ab == "b"]<-exif_out$new_img_num[exif_out$ab == "b"]+10000

library(stringr)
exif_out$new_img_num<-str_pad(exif_out$new_img_num, 6, pad = "0")

site_split<-strsplit(exif_out$site_cam, "_")

###getting the site id out of site_cam

get_first<-function(x){
  site_out<-x[[1]]
  return(site_out)
}

site_id<-lapply(site_split, get_first)
site_ids<-unlist(site_id)

exif_out$site_id<-site_ids



###new file path with new image numbers 

file_split<-strsplit(as.character(exif_out$filepath), "/")

remove_last<-function(x){
 image_out<-x[-length(x)]
 # image_out_img<-paste("2018",image_out[2], sep = "_")
 image_out<-paste(image_out, collapse = "/", sep="")
 return(image_out)
}

image_nos<-lapply(file_split, remove_last)
img_nos<-unlist(image_nos)

exif_out$filepath_image_rename<-paste(img_nos, "/","2018_",exif_out$site_id,"_" ,exif_out$new_img_num,".JPG", sep= "")


#file.rename(as.character(exif_out$filepath), exif_out$filepath_image_rename)



