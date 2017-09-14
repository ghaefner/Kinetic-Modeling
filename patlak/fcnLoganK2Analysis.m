function [ LoganSlopesK2 ] = fcnLoganK2Analysis ( pathInputImage, pathReferenceVOI, startframe, timepoints )
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

LoganSlopes = single(zeros(xDim,yDim,zDim));

%% Calculate the TAC_ReferenceVOI and activity integral
% Take timepoints.*10 for calculating the integrals because 1 frame
% corresponds to 10 minutes. Change here, if needed.

k2_prime = 18304.0;
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints.*10, 1, TAC_ReferenceVOI);


parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim
            
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints.*10,1,TAC );
            LoganSlopes(i,j,k) = calcLoganK2(TAC, timepoints, startframe, IntegralsOfActivityInVoxel, IntegralsOfActivityInReferenceRegion, k2_prime, TAC_ReferenceVOI);
            
        end
    end
end


image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = LoganSlopes;

LoganSlopesK2 = image4D;


end

