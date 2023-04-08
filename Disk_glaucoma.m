% Clean
clc;clear all;close all

% Select the specific folder that contains the images to be pre-processed.
myFolder = uigetdir();

% Image format
a='*.jpg';
b='*.png';
c='*.jpeg';
d='*.bmp';
e='*.tiff';
list = {a,b,c,d,e};
[indx,tf] = listdlg('PromptString',{'Image format - Database.','Only one file can be selected.',''},'SelectionMode','single','ListString',list,'ListSize',[250,150]);
alfa=char(list(indx));
filePattern = fullfile(myFolder, alfa);
theFiles = dir(filePattern);

% Seleccionar que hacer
list = {'Crop',...
    'Algo',...
    'Otro'};

[ind,tf] = listdlg('PromptString',{'Select a function.','Only one option can be selected at a time.',''},'SelectionMode','single','ListString',list,'ListSize',[250,150]);

% Programa
for k = 1 : length(theFiles)
    % Take the name of the image
    baseFileName = theFiles(k).name;
    % Path of the image
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    % Seleccionar que parte cortar automaticamente
    if ind==1
        Img=imread(fullFileName);
        [J,rect] = imcrop(Img);
        I2 = imcrop(Img,[rect(1,1)-32 rect(1,2)-32 226 226]);
        size(I2)
        %figure(1),imshow(I2),title('Crop');
        imwrite(I2,fullFileName)
    % Otra cosa
    elseif ind==2
        Img=imread(fullFileName);
        Img=size(Img);
    % Otra cosa
    else
        Img=imread(fullFileName);
        Img=size(Img);
    end
    drawnow; % Force display to update immediately.
end
