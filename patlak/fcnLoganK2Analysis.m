function [ DVRs ] = fcnLoganK2Analysis ( pathInputImage, pathReferenceVOI, averageK2Prime, startframe, timepoints )
%UNTITLED3 Summary of this function goes here
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

DVRs = single(zeros(xDim,yDim,zDim));

%% Calculate the TAC_ReferenceVOI and activity integral


TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, startframe, TAC_ReferenceVOI);


parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints,1,TAC );
            DVRs(i,j,k) = calcLoganK2(TAC, timepoints, startframe, IntegralsOfActivityInVoxel, IntegralsOfActivityInReferenceRegion, averageK2Prime, TAC_ReferenceVOI);
            
        end
    end
end
% Eliminate unphysiological values
%DVRs = DVRs.*double(DVRs < 20);

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = DVRs;

DVRs = image4D;


end

