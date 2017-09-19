function [Ks] = fcnPatlak( pathInputImage, pathReferenceVOI, timepoints, startFrame )
%UNTITLED5 Summary of this function goes here
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
Ks = single(zeros(xDim,yDim,zDim));


%% Loop over every voxel
parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k]);
            Ks(i,j,k) = calcPatlak(timepoints,startFrame,TAC,TAC_ReferenceVOI,IntegralsOfActivityInRegion);        
        end
    end
end

disp(Ks);
disp(sum(Ks(:)));
% image4D.hdr.dime.dim(1) = 3;
% image4D.hdr.dime.dim(5) = 1;
% image4D.img = Ks;
% 
% Ks = image4D;

end

