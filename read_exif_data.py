import PIL.Image
import PIL.ExifTags
import os
import glob
import sys
import pickle

keys = ['Make', 'Model', 'DateTime','LightSource', 'Flash']
path_in = 'M:/biome_health_project_files/country_files/kenya/raw_data/'

#allfiles=[]
#for path, subdirs, files in os.walk(path_in):
#    for f in files:
#      if (f.endswith(".JPG") or f.endswith(".jpg")) and os.path.getsize(os.path.join(path,f)) > 0:
#         allfiles.append(os.path.join(path,f))

#pickle.dump(allfiles, "allfiles.txt")


with open("D:/Fiona/Biome_Health_Project/allfiles.txt", "rb") as fp:   # Unpickling
   allfiles = pickle.load(fp)

sys.stdout = open(os.path.join('D:/Fiona/Biome_Health_Project/exif_output/exif_out5.txt'), "w")

for image in allfiles:
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
