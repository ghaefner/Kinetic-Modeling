function [ numberOfFiles ] = calcNumberOfFiles( pathImagesToProcessFolder )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

subj=dir(strcat(pathImagesToProcessFolder,'/','*.nii'));
numberOfFiles=length(subj);


end

