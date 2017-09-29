function [ DVRs, chiSquareROI ] = fcnLoganK2Analysis ( pathInputImage, pathReferenceVOI, averageK2Prime, startframe, lengthFrame,pOI, numberOfFrames)
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

timepoints = 1:numberOfFrames:(floor(size(image4D.img,4)/numberOfFrames)*numberOfFrames);

DVRs = single(zeros(xDim,yDim,zDim));

%% Calculate the TAC_ReferenceVOI and activity integral
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI, numberOfFrames );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(startframe, TAC_ReferenceVOI, lengthFrame, numberOfFrames);


parfor i = 1:xDim
    warning('off','all');
    for j = 1:yDim
        for k = 1:zDim
            TAC = extractTACFromVoxel(image4D, [i j k], numberOfFrames);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel(startframe,TAC,lengthFrame, numberOfFrames );
            DVRs(i,j,k) = calcLoganK2(TAC, timepoints, startframe, IntegralsOfActivityInReferenceRegion,IntegralsOfActivityInVoxel, averageK2Prime, TAC_ReferenceVOI);
            
        end
    end
end


%% Plot data for ROI
% Get data
xLoganK2 = zeros(length(timepoints)-startframe+1,1);
yLoganK2 = zeros(length(timepoints)-startframe+1,1);

TAC = extractTACFromVoxel(image4D, [pOI(1), pOI(2), pOI(3)], numberOfFrames);            
IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( startframe,TAC,lengthFrame,numberOfFrames );
[~,LoganK2Intercept,xLoganK2(:),yLoganK2(:),chiSquareROI] = calcLoganK2(TAC, timepoints, startframe, IntegralsOfActivityInReferenceRegion, IntegralsOfActivityInVoxel, averageK2Prime, TAC_ReferenceVOI);

% Plot

figure(1);

plot(xLoganK2(:),yLoganK2(:),'b*');
axis([0 max(xLoganK2(:))*1.3 0 max(yLoganK2(:))*1.3 ]);
ylabel('\int_0^T C(t)dt / C(T)  [min]')
xlabel('(\int_0^TC_{ref}(t)dt+C_{ref}(T)/k2_{ref})/C(T)  [min]')
hold on
plot(xLoganK2(:),xLoganK2(:)*DVRs(pOI(1),pOI(2),pOI(3))+LoganK2Intercept,'r-');
hold off


%% Make output image

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = DVRs;

DVRs = image4D;


end

