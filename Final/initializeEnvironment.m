function [ pathImagesToProcessFolder,pathReferenceVOI ] = initializeEnvironment()
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

pathImagesToProcessFolder = uigetdir('.','Choose your Input Folder:');
pathReferenceVOI = uigetfile({'*.nii'},'Choose your Reference File:');
end

