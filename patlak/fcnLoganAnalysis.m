function [ LoganSlopes ] = fcnLoganAnalysis ( pathInputImage, pathReferenceVOI, startframe, timepoints )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Load image and referenceVOI
image4D = load_nii(pathInputImage);

referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);

LoganSlopes = single(zeros(sizeInputImage(1),sizeInputImage(2),sizeInputImage(3)));

%% Calculate the TAC_ReferenceVOI and activity integral
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, 1, TAC_ReferenceVOI);


parfor i = 1:79
    for j = 1:95
        for k = 1:78
            
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints,1,TAC );
            LoganSlopes(i,j,k) = calculateKi(TAC, timepoints, startframe, IntegralsOfActivityInVoxel, IntegralsOfActivityInReferenceRegion);
            
        end
    end
    %disp(i);
end


image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = LoganSlopes;

LoganSlopes = image4D;


end

