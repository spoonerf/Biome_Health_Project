######### new file structure


exif_out<-read.csv("rename_image_file.csv")

exif_out$site<-gsub('[[:digit:]]+', '', exif_out$site_id)

base_path<-"M:/biome_health_project_files/country_files/kenya/working_data"

#camera trap or audio
data_type<-"CT"
year<-"2018"


exif_out$new_file_structure<-paste(base_path,"/",exif_out$site,"/",exif_out$site_id,"/",data_type,"/" ,year,"/",year,"_", site_id,"_",exif_out$new_img_num,".JPG", sep= "")

exif_out$new_dir_structure<-paste(base_path, exif_out$site,exif_out$site_id,data_type, year, sep= "/")


dir_creator<-function(x){
  
  dir.create(x, recursive = TRUE)  
  
}

lapply(unique(exif_out$new_dir_structure), dir_creator)

saveRDS(exif_out, "original_filepaths_working_filepaths.RDS")

file.rename(exif_out$filepath_image_rename, exif_out$new_file_structure)






