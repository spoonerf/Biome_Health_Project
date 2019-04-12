import PIL.Image
import PIL.ExifTags
import os
import glob
import sys
import pickle

keys = ['Make', 'Model', 'DateTime','LightSource', 'Flash']
path_in = 'M:/biome_health_project_files/country_files/kenya/raw_data/'
#path_in = 'M:/biome_health_project_files/country_files/kenya/raw_data/corrupted_exif/omc-october/'
#path_in = 'M:/biome_health_project_files/country_files/kenya/raw_data/corrupted_exif/naboisho_november/NB20_CT07/'
#path_in = 'D:/Fiona/Biome_Health_Project/test_exif/mara_north_november/MN02_CT160'

#allfiles=[]
#for path, subdirs, files in os.walk(path_in):
#    for f in files:
#      if (f.endswith(".JPG") or f.endswith(".jpg")) and os.path.getsize(os.path.join(path,f)) > 0:
#         allfiles.append(os.path.join(path,f))

with open("D:/Fiona/Biome_Health_Project/allfiles.txt", "rb") as fp:   # Unpickling
   allfiles = pickle.load(fp)

sys.stdout = open(os.path.join('D:/Fiona/Biome_Health_Project/exif_output/exif_out5.txt'), "w")

for image in allfiles[251299:len(allfiles)]:
    try:
        img = PIL.Image.open(image)
        #print('Good file')
    except OSError as e:
        print('Bad file ' + image)
    exif = {
    PIL.ExifTags.TAGS[k]: v
    for k, v in img._getexif().items()
    if k in PIL.ExifTags.TAGS
    }
    keys_out = [str(exif.get(key)) for key in keys]
    filepath = str(image)
    #print(filepath)
    sfp = filepath.split("/")[len(filepath.split("/")) - 1]
    sfp = sfp.split("\\")
    if len(sfp) == 4:
        an = sfp[0]
        sn = sfp[1]
        sn2 = sfp[2]
        fn = sfp[3]
        print(an+ ", " + sn + ', ' + sn2 + ', ' + fn + ', ' + ', '.join(keys_out))
        if len(sfp) == 3:
            an = sfp[0]
            sn = sfp[1]
            fn = sfp[2]
            print(an+ ", " + sn + ', ' + 'NULL' + ', ' + fn + ', ' + ', '.join(keys_out))


############### alternative code ##############################
###saves filepath rather than information extracted from it####

for image in allfiles[251299:len(allfiles)]:
    try:
        img = PIL.Image.open(image)
    except OSError as e:
        print('Bad file ' + image)
    exif = {
    PIL.ExifTags.TAGS[k]: v
    for k, v in img._getexif().items()
    if k in PIL.ExifTags.TAGS
    }
    keys_out = [str(exif.get(key)) for key in keys]
    filepath = str(image)
    print(filepath + ', ' + ', '.join(keys_out)) 

#with open("D:/Fiona/Biome_Health_Project/allfiles.txt", "wb") as fp:   #Pickling
#   pickle.dump(allfiles, fp)


#with open("D:/Fiona/Biome_Health_Project/allfiles.txt", "rb") as fp:   # Unpickling
#   b = pickle.load(fp)
