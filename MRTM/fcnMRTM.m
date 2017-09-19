function [ bindingPotentials, averageK2Prime ] = fcnMRTM( pathInputImage, pathReferenceVOI, timepoints, startFrame )
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

%% Calculate reference values
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, startFrame, TAC_ReferenceVOI);
bindingPotentials = single(zeros(xDim,yDim,zDim));
k2Primes = single(zeros(xDim,yDim,zDim));

%% Loop over every voxel
parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints,1,TAC );
            [bindingPotentials(i,j,k), k2Primes(i,j,k)] = calcMRTM(timepoints,startFrame,TAC,TAC_ReferenceVOI,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);        

        end
    end
end

averageK2Prime = sum(k2Primes(:))/(length(k2Primes(:)));

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = bindingPotentials;

bindingPotentials = image4D;

end

