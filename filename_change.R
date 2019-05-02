library(here)

exif_out<-read.table(here("/exif_output/exif_out_new.txt"), fill = NA, sep = ",", stringsAsFactors = FALSE)

colnames(exif_out)<-c("filepath", "Camera_brand", "Camera_model", "datetime","datetime_digitized", "Light_source", "Flash")

bad_files<-exif_out[grepl("Bad file", exif_out$filepath),]

exif_out<-exif_out[!grepl("Bad file", exif_out$filepath),]


#get rid of files in corrupted_exif folder

exif_out<-exif_out[!grepl("corrupted_exif", exif_out$filepath),]


###Getting image number out of filepath
file_split<-strsplit(exif_out$filepath, "[\\\\]|[^[:print:]]")

get_last<-function(x){
  image_out<-x[[length(x)]]
  return(image_out)
}

image_nos<-lapply(file_split, get_last)
img_nos<-unlist(image_nos)

exif_out$image_no<-img_nos

exif_out$image_num<-as.numeric(gsub("[^0-9]", "",exif_out$image_no))


##Getting the site and camera id for each image

get_second_last<-function(x){
  image_out<-x[[(length(x)-1)]]
  if(grepl("BTCF",image_out)){
    image_out<-x[[(length(x)-2)]]
  }
  
  image_out<-strsplit(image_out, "_")[[1]][1]
  
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

exif_out$new_img_num[exif_out$ab == "b"]<-exif_out$image_num[exif_out$ab == "b"]+10000

library(stringr)
exif_out$new_img_num<-str_pad(exif_out$new_img_num, 6, pad = "0")

site_split<-strsplit(exif_out$site_cam, "_")

# ###getting the site id out of site_cam 
# 
# get_first<-function(x){
#   site_out<-x[[1]]
#   return(site_out)
# }
# 
# site_id<-lapply(site_split, get_first)
# site_ids<-unlist(site_id)
# 
# exif_out$site_id<-site_ids
# 


###new file path with new image numbers 

file_split<-strsplit(exif_out$filepath, "[\\\\]|[^[:print:]]")

remove_last<-function(x){
 image_out<-x[-length(x)]
 # image_out_img<-paste("2018",image_out[2], sep = "_")
 image_out<-paste(image_out, collapse = "/", sep="")
 return(image_out)
}

image_nos<-lapply(file_split, remove_last)
img_nos<-unlist(image_nos)

exif_out$filepath_image_rename<-paste(img_nos, "/","2018_",exif_out$site_id,"_" ,exif_out$new_img_num,".JPG", sep= "")

exif_out$filepath_image_rename<-str_replace(exif_out$filepath_image_rename, pattern = "raw_data", replacement = "working_data")


exif_out$filepath_working<-str_replace(exif_out$filepath, pattern = "raw_data", replacement = "working_data")

exif_out$filepath_working<-gsub("\\", "/", exif_out$filepath_working, fixed = TRUE)


exif_out[exif_out$site_cam == "MN14" & exif_out$month == "november" & exif_out$ab == "b",]



file.rename(exif_out$filepath_working, exif_out$filepath_image_rename)







#files_moved_clean[files_moved_clean %in% exif_out$filepath_working] 


#files_moved<-list.files("M:/biome_health_project_files/country_files/kenya/working_data/", recursive = TRUE, full.names = TRUE)

# saveRDS(files_moved, "list_files_RDS_working.rds")
files_moved_read<-readRDS("list_files_RDS_working.rds")

files_moved_clean<-files_moved_read[grepl(".JPG", files_moved_read)]


file_split<-strsplit(files_moved_clean, "/")

get_last_two<-function(x){
  image_out<-x[[length(x)]]
  site_out<-x[[(length(x)-1)]]
  
  if(grepl("BTCF",site_out)){
    site_out<-x[[(length(x)-2)]]
  }
  
  site_out<-strsplit(site_out, "_")[[1]][1]
  
  both_out<-c(site_out, image_out)
  return(both_out)
}



image_nos<-lapply(file_split, get_last_two)
img_nos<-matrix(unlist(image_nos), ncol = 2, byrow = T)



exif_out$filepath_working<-str_replace(exif_out$filepath, pattern = "raw_data", replacement = "working_data")








clean_file_df<-data.frame(files_moved_clean, img_nos)
colnames(clean_file_df)<-c("file_path_clean", "site_cam", "image_no")









clean_col<-paste(clean_file_df$site_cam, clean_file_df$image_no, collapse = "_")
old_col<-paste(exif_out$site_cam, exif_out$image_no, collapse = "_")

##need to add year to new filenames


clean_col[!clean_col %in% old_col]


file.copy(files_moved_clean[1:5], exif_out$filepath_image_rename[1:5])










