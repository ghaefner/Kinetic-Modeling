function [ bindingPotentials, averageK2Prime, stDevK2Prime, averageChiSquare ] = fcnMRTM( pathInputImage, pathReferenceVOI, timepoints, startFrame )
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
k2Primes = single(zeros(xDim,yDim,zDim));
chiSquare = single(zeros(xDim,yDim,zDim));

%% Calculate reference values
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, startFrame, TAC_ReferenceVOI);

%% Fill every voxel and calculate model parameters
parfor i = 1:xDim
    warning('off','all');
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints,1,TAC );
            [bindingPotentials(i,j,k), k2Primes(i,j,k),chiSquare(i,j,k)] = calcMRTM(timepoints,startFrame,TAC,TAC_ReferenceVOI,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);        
        end
    end
end

%% Output values
% Weight k2Primes without referenceVOI
%k2PrimesReference = k2Primes.*(abs(referenceVOI-1));
k2PrimesReference = k2Primes.*referenceVOI;

% Using nan function to calculate means
averageK2Prime = nanmean(k2PrimesReference(:));
stDevK2Prime = nanstd((k2PrimesReference(:)),1)*sqrt(1/(length(k2PrimesReference(:))-1));
averageChiSquare = nanmean(chiSquare(:));

disp(averageK2Prime);

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = bindingPotentials;

bindingPotentials = image4D;

end

