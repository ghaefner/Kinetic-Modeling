function [ LoganSlopes,chiSquareROI ] = fcnLoganAnalysis ( pathInputImage, pathReferenceVOI, startframe, lengthFrame, pOI, numberOfFrames )
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

LoganSlopes = single(zeros(xDim,yDim,zDim));

%% Calculate the TAC_ReferenceVOI and activity integral

TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI, numberOfFrames );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(startframe, TAC_ReferenceVOI, lengthFrame, numberOfFrames);


parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim
            TAC = extractTACFromVoxel(image4D, [i j k], numberOfFrames);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( startframe,TAC,lengthFrame,numberOfFrames );
            LoganSlopes(i,j,k) = calcLogan(timepoints, startframe, TAC, IntegralsOfActivityInReferenceRegion, IntegralsOfActivityInVoxel);
            
        end
    end
end


%% Plot data for ROI
% Get data
xLogan = zeros(length(timepoints)-startframe+1,1);
yLogan = zeros(length(timepoints)-startframe+1,1);

TAC_ROI = extractTACFromVoxel(image4D, [pOI(1), pOI(2), pOI(3)], numberOfFrames);            
IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( startframe,TAC_ROI,lengthFrame,numberOfFrames );
[~,LoganIntercept,xLogan(:),yLogan(:),chiSquareROI] = calcLogan(timepoints, startframe, TAC_ROI, IntegralsOfActivityInReferenceRegion, IntegralsOfActivityInVoxel);
            
% Plot
figure(1);

plot(xLogan(:),yLogan(:),'b*');
axis([0 max(xLogan(:))*1.2 0 max(yLogan(:))*1.2 ]);
disp(xLogan);
%disp(yLogan);
xlabel('\int_0^T C_{ref}(t)dt / C(T)  [min]')
ylabel('\int_0^TC(t)dt/C(T)  [min]')
hold on
plot(xLogan(:),xLogan(:)*LoganSlopes(pOI(1),pOI(2),pOI(3))+LoganIntercept,'r-');
hold off


%% Make output image
image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = LoganSlopes;

LoganSlopes = image4D;


end

