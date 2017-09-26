function [ bindingPotentials, k2s, averageChiSquare ] = fcnSRTM( pathInputImage, pathReferenceVOI, timepoints, startFrame )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%% Load image and referenceVOI
image4D = load_nii(pathInputImage);

referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);
xDim = sizeInputImage(1);
yDim = sizeInputImage(2);
zDim = sizeInputImage(3);

bindingPotentials = single(zeros(xDim,yDim,zDim));
k2s = single(zeros(xDim,yDim,zDim));
chiSquare = single(zeros(xDim,yDim,zDim);

%% Calculate reference values
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints,startFrame,TAC_ReferenceVOI);

parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k]);
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel(timepoints,startFrame,TAC);
            [ bindingPotentials(i,j,k), k2s(i,j,k), chiSquare(i,j,k) ] = calcSRTM(timepoints, startFrame, TAC, IntegralsOfActivityInRegion, IntegralsOfActivityInVoxel);        
        end
    end
end

averageChiSquare = nanmean(chiSquare(:));
% 
% disp(['k2 for ROI = [10 10 10]: ', num2str(k2s(10,10,10))]);
% disp(['BP for ROI = [10 10 10]: ', num2str(bindingPotentials(10,10,10))]);
% disp(['k2 for ROI = [50 50 50]: ', num2str(k2s(50,50,50))]);
% disp(['BP for ROI = [50 50 50]: ', num2str(bindingPotentials(50,50,50))]);

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = bindingPotentials;

bindingPotentials = image4D;

end