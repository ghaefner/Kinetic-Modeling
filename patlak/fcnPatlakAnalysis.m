function [ PatlakSlopes ] = fcnPatlakAnalysis(pathInputImage, pathReferenceVOI, startframe, timepoints)

%% Load image and referenceVOI
image4D = load_nii(pathInputImage);

referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);

%% Calculate the TAC_ReferenceVOI and activity integral
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, 1, TAC_ReferenceVOI);

%% Calculate the PatlakSlopes using calculateKi for every pixel
PatlakSlopes = single(zeros(sizeInputImage(1),sizeInputImage(2),sizeInputImage(3)));

% Ranges are hardcoded because of parralelization
parfor i = 1:79
    for j = 1:95
        for k = 1:78
            
            TAC = extractTACFromVoxel(image4D, [i j k]);
            PatlakSlopes(i,j,k) = calculateKi(TAC, timepoints, startframe, TAC_ReferenceVOI, IntegralsOfActivityInReferenceRegion);
            
        end
    end
    disp(i);
end

% PatlakSlopesNii = referenceVOInii;
% PatlakSlopesNii.img = PatlakSlopes;

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = PatlakSlopes;

PatlakSlopes = image4D;



end

