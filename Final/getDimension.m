function [ xDim, yDim, zDim ] = getDimension( pathImageToProcessFolder )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

pathImageToProcessFolder = [pathImageToProcessFolder, '/'];
%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImageToProcessFolder,'*.nii'));

image = load_nii([pathImageToProcessFolder subj(1).name]);

xDim = size(image.img,1);
yDim = size(image.img,2);
zDim = size(image.img,3);

end

