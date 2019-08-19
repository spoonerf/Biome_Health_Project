all_images<-read.csv("D:/Fiona/Biome_Health_Project/all_images.csv")
all_images$CaptureEventID<-as.character(all_images$CaptureEventID)
all_images$URL_Info<-as.character(all_images$URL_Info)

consensus<-read.csv("D:/Fiona/Biome_Health_Project/consensus_data.csv")
consensus$CaptureEventID<-as.character(consensus$CaptureEventID)

all_df<-merge(all_images, consensus, by = "CaptureEventID")


###filtering out species with lots of images

f_df<-all_df %>%
  filter(Species != "human", Species != "zebra", Species != "gazelleThomson", Species != "buffalo", 
         Species != "hartebeest", Species != "elephant", Species != "human", Species!= "giraffe", 
         Species != "impala", Species != "guineaFowl", Species != "gazelleGrants", Species != "warthog",
         Species != "otherBird", Species != "hyenaSpotted")

f_df$download_url<-paste0("https://snapshotserengeti.s3.msi.umn.edu/", f_df$URL_Info)
f_df$new_location<-paste0("M:/biome_health_project_files/country_files/kenya/serengeti/", f_df$Species,"/", basename(f_df$URL_Info))

new_dirs<-paste0("M:/biome_health_project_files/country_files/kenya/serengeti/", unique(f_df$Species))
for (dir in new_dirs){
  dir.create(dir)  
  
}

for (i in 1:nrow(f_df)){
  download.file(f_df$download_url[i], f_df$new_location[i], mode = "wb")  
  print(i)
}
