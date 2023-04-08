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
filePattern = fullfile(myFolder, alfa); % Change to whatever pattern you need.
theFiles = dir(filePattern);

% Seleccionar que hacer
% Escalamiento, Filtro rojo o Recortar areas negras
list = {'Luminosity correction',...
    'Contrast enhancement',...
    'Normalize',...
    'Green channel',...
    'Resize (227x227 px)',...
    'All',...
    'Cropping black areas - Images'};

[ind,tf] = listdlg('PromptString',{'Select a function.','Only one option can be selected at a time.',''},'SelectionMode','single','ListString',list,'ListSize',[250,150]);



for k = 1 : length(theFiles)
    % Take the name of the image
    baseFileName = theFiles(k).name;
    % Path of the image
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    % Luminosity correction
    if ind==1
        % Input
        imageArray= imread(fullFileName);
        %figure('Name','Input'),imshow(imageArray);
        [a,b]=size(imageArray);
        % A HSV
        HSV = rgb2hsv(imageArray);
        HSVH=HSV(:,:,1);
        HSVS=HSV(:,:,2);
        HSVV=HSV(:,:,3);
        HSVd = double(HSVV);
        %figure('Name','V'),imshow(HSVd);
        [r,c]=size(HSVd);
        gamma=0.5;
        out=abs((1*HSVd).^gamma);
        %figure('Name','Gamma'),imshow(out);
        
        Z = imdivide(HSVd,out);
        %figure('Name','G tilde'),imshow(Z);

        % Opcion 1
        Fi=cat(3,HSVH,HSVS,Z);
        %figure('Name','todohsv'),imshow(Fi);
        Fi = hsv2rgb(Fi);
        %figure('Name','Op1'),imshow(Fi);

        %{
        % Opcion 2 (Dana la imagen)
        Fi=uint8(Fi);
        A = immultiply(imageArray,Fi);
        %figure('Name','Op2'),imshow(A);

        % Opcion 3 (Es igual al input)
        ZZ=uint8(Z);
        imageArrayR=imageArray(:,:,1);
        imageArrayR=immultiply(ZZ,imageArrayR);

        imageArrayG=imageArray(:,:,2);
        imageArrayG=immultiply(ZZ,imageArrayG);

        imageArrayB=imageArray(:,:,3);
        imageArrayB=immultiply(ZZ,imageArrayB);
        ffinal=cat(3,imageArrayR,imageArrayG,imageArrayB);
        size(ffinal)
        %figure('Name','Op3'),imshow(ffinal);

        % Opcion 4
        imageArray=rgb2hsv(imageArray);
        imageArrayR=imageArray(:,:,1);
        imageArrayR=immultiply(Z,imageArrayR);

        imageArrayG=imageArray(:,:,2);
        imageArrayG=immultiply(Z,imageArrayG);

        imageArrayB=imageArray(:,:,3);
        imageArrayB=immultiply(Z,imageArrayB);
        fffinal=cat(3,imageArrayR,imageArrayG,imageArrayB);
        fffinal=hsv2rgb(fffinal);
        size(fffinal)
        %figure('Name','Op4'),imshow(fffinal);
        %}
        imwrite(Fi,fullFileName);

    % Contrast enhancement
    elseif ind==2
        lab= imread(fullFileName);
        %figure('Name','Adapthisteq Image'),imshow(lab);
        %figure('Name','Adapthisteq Histogram'),imhist(lab);
        % A toda la imagen
        %i=rgb2gray(lab);
        %h2=adapthisteq(i,'ClipLimit',0.009);
        %imwrite(h2,fullFileName);

        % A la parte l del lab
        CT=makecform('srgb2lab');
        lab=applycform(lab,CT);
        llab=lab(:,:,1);
        llab=adapthisteq(llab,'ClipLimit',0.009);
        alab=lab(:,:,2);
        blab=lab(:,:,3);
        Fi=cat(3,llab,alab,blab);
        Fi=double(Fi);
        out=lab2rgb(Fi);
        %figure('Name','Adapthisteq Image'),imshow(out);
        %figure('Name','Adapthisteq Histogram'),imhist(out);
        imwrite(out,fullFileName);

    % Normalize
    elseif ind==3
        imageArray= imread(fullFileName);
        normImage = mat2gray(imageArray);
	    normImage = im2double(normImage);
        %figure('Name','Normalize'),imshow(normImage);
	    imwrite(normImage,fullFileName);

    % Green channel
    elseif ind==4
        imageArray=imread(fullFileName);
        %{
        % Opcion 1
        greenchannel=imageArray(:,:,2);
        allBlack = zeros(size(imageArray, 1), size(imageArray, 2), 'uint8');
        just_green = cat(3, allBlack, greenchannel, allBlack);
        figure('Name','Green'),imshow(just_green);
        imwrite(just_green,fullFileName);
        %}
        % Opcion 2
        imageArrayR=imageArray(:,:,1);
        %figure('Name','Red'),imshow(imageArrayR);
        imageArrayG=imageArray(:,:,2);
        %figure('Name','Green'),imshow(imageArrayG);
        imageArrayB=imageArray(:,:,3);
        %figure('Name','Blue'),imshow(imageArrayB);
        imwrite(imageArrayG,fullFileName);

    % Resize the images
    elseif ind==5
        imageArray= imread(fullFileName);
        img= imresize(imageArray,[227 227]);
        imwrite(img,fullFileName);
    
    % All in one
    elseif ind==6
        % Luminosity correction
        imageArray= imread(fullFileName);
        [a,b]=size(imageArray);
        HSV = rgb2hsv(imageArray);
        HSVH=HSV(:,:,1);
        HSVS=HSV(:,:,2);
        HSVV=HSV(:,:,3);
        HSVd = double(HSVV);
        [r,c]=size(HSVd);
        gamma=0.8;
        out=abs((1*HSVd).^gamma);        
        Z = imdivide(HSVd,out);
        % Opcion 1
        Fi=cat(3,HSVH,HSVS,Z);
        Fi = hsv2rgb(Fi);
        imwrite(Fi,fullFileName);
        % Contrast enhancement
        lab= imread(fullFileName);
        CT=makecform('srgb2lab');
        lab=applycform(lab,CT);
        llab=lab(:,:,1);
        llab=adapthisteq(llab,'ClipLimit',0.009);
        alab=lab(:,:,2);
        blab=lab(:,:,3);
        Fi=cat(3,llab,alab,blab);
        Fi=double(Fi);
        out=lab2rgb(Fi);
        imwrite(out,fullFileName);
        % Normalize
        imageArray= imread(fullFileName);
        normImage = mat2gray(imageArray);
	    normImage = im2double(normImage);
	    imwrite(normImage,fullFileName);
        % Green channel
        imageArray=imread(fullFileName);
        % Opcion 2
        imageArrayG=imageArray(:,:,2);
        imwrite(imageArrayG,fullFileName);

    % Crop black border of images
    else
        imageCOLOR= imread(fullFileName);
        imageRGB = imageCOLOR;
        imageArray = rgb2gray(imageRGB);
        binaryImage = imbinarize(imageArray);
        [rows, columns] = find(binaryImage);
        topRow = min(rows);
        bottomRow = max(rows);
        leftColumn = min(columns);
        rightColumn = max(columns);
        croppedImage = imcrop(imageCOLOR,[leftColumn topRow (rightColumn-leftColumn) (bottomRow-topRow)]);
        imwrite(croppedImage,fullFileName);
    end
    drawnow; % Force display to update immediately.
end
