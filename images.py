import os
import shutil
# --------------------------------------------------------------------------------
# Path de las images
dir = '/home/javier/Downloads/Dataset_all/ImageData3/Sus_G'
content=os.listdir(dir)
images=[]
for fichero in content:
    if os.path.isfile(os.path.join(dir,fichero)) and fichero.endswith('.jpg'):
        images.append(fichero)

# Path del dataset original
dir = '/home/javier/Downloads/ODIR-5K_Training_Images/ODIR-5K_Training_Dataset'
content=os.listdir(dir)
images_orig=[]
for fichero in content:
    if os.path.isfile(os.path.join(dir,fichero)) and fichero.endswith('.jpg'):
        images_orig.append(fichero)

destination='/home/javier/Downloads/ODIR_original/Sus_G'
count=0
for i in images:
    if i in images_orig:
        full_path=dir+'/'+i
        shutil.copy(full_path,destination)
        count+=1
print(count)
