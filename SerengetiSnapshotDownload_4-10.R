library(jsonlite)
library(rjson)
library(dplyr)

ss <- fromJSON(txt = "SnapshotSerengetiBboxes_20190409.json")
    
image_id<-ss$annotations$image_id
bbox_c<-ss$annotations$bbox
file_name<-ss$images$file_name




meta_anot <- read.csv("SnapshotSerengeti_v2_0_annotations.csv")
meta_imag <- read.csv("SnapshotSerengeti_v2_0_images.csv")


img_anot<-merge(meta_anot, meta_imag, by = "capture_id")



f_df<-img_anot %>%
  filter(question__species != "human", question__species != "zebra", 
         question__species != "gazelleThomsons", question__species != "buffalo", 
         question__species != "hartebeest", question__species != "elephant", 
         question__species != "human", question__species!= "giraffe", 
         question__species != "impala", question__species != "guineaFowl", 
         question__species != "gazelleGrants", question__species != "warthog",
         question__species != "otherBird", question__species != "hyenaSpotted",
         question__species != "blank", question__species != "wildebeest",
         season != "S1", season != "S2", season != "S3")

f_df$download_url<-paste0("https://snapshotserengeti.s3.msi.umn.edu/", f_df$image_path_rel)
f_df$new_location<-paste0("M:/biome_health_project_files/country_files/kenya/serengeti/", as.character(f_df$question__species),"/", basename(as.character(f_df$image_path_rel)))


new_dirs<-paste0("M:/biome_health_project_files/country_files/kenya/serengeti/", unique(as.character(f_df$question__species)))

for (dir in new_dirs){
  if(!file.exists(dir)){
    dir.create(dir)  
    }
  }

for (i in 17547:nrow(f_df)){
  download.file(f_df$download_url[i], f_df$new_location[i], mode = "wb", quiet = TRUE)  
  print(i)
}





