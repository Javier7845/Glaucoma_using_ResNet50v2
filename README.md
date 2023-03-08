This repository contains both the code to pre-process the images and the code to train the Keras ResNet-50v2 neural network in the task of detecting glaucoma in retinal fundus images.
First, the images to be trained must be pre-processed with the script *Code_matlab.m* in Matlab.
## Steps:
1. Open Matlab and run the script. A window will appear in which you will be asked to select the directory where the images to be processed are located.
2. Another window will appear in which you will have to select the format of the images to be processed.
4. Finally, another window will open in which you will have to select which process to apply to the images.

The images were treated for: Luminosity correction, contrast enhancement, normalization and selection of the green channel. So you should choose all these options one after the other. Additionally, the script must be run choosing the "Crop black areas" and "resize images" options to delete the black areas that accompany the retina background images and readjust the size of the images to train the network (227 x 227 px). In addition, the script must be run for each image format found in the directories.

Once the images have been processed, open the notebook that contains all the code to load the images and train the model.
## Steps:
1. Upload the folder with all the images to train. The directory should look like this:
```
|——all_data
    |——Non_D
    |——Sus_G
```
2. Execute all the lines until training the model.
