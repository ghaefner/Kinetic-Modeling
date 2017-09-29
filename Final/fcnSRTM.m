function [ bindingPotentials,chiSquareROI,averageK2 ] = fcnSRTM( pathInputImage, pathReferenceVOI, startframe, lengthFrame, pOI, numberOfFrames )
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

timepoints = 1:numberOfFrames:(floor(size(image4D.img,4)/numberOfFrames)*numberOfFrames);

%% Calculate reference values
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI, numberOfFrames );
IntegralsOfActivityInRegion = calculateIntegralsOfActivityInReferenceRegion(startframe,TAC_ReferenceVOI,lengthFrame, numberOfFrames);

bindingPotentials = single(zeros(xDim,yDim,zDim));
k2s = single(zeros(xDim,yDim,zDim));

parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k], numberOfFrames);
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel(startframe,TAC,lengthFrame, numberOfFrames);
            [bindingPotentials(i,j,k), k2s(i,j,k)] = calcSRTM(timepoints,startframe,TAC,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);   
        end
    end
end

%% Calculate average k2 weighting with inverse ReferenceVOI
k2nonReference = k2s.*abs(1-referenceVOI);
averageK2 = nanmean(k2nonReference(:));

%% Plot image for ROI
% Get data
coeffs = zeros(2,1);
xSRTM1 = zeros(length(timepoints)-startframe+1,1);
xSRTM2 = zeros(length(timepoints)-startframe+1,1);
ySRTM = zeros(length(timepoints)-startframe+1,1);

TAC_ROI = extractTACFromVoxel(image4D, [pOI(1), pOI(2), pOI(3)], numberOfFrames);            
IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( startframe,TAC_ROI,lengthFrame,numberOfFrames );
[~,~,chiSquareROI,coeffs(:),xSRTM1(:),xSRTM2(:),ySRTM(:)] = calcSRTM(timepoints,startframe,TAC_ROI,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);        

% Plot
figure(1);

plot((startframe:length(timepoints)).*lengthFrame*numberOfFrames,ySRTM(startframe:length(timepoints)),'b*');
axis([0 (max(timepoints(:))+1)*lengthFrame*numberOfFrames 0 max(ySRTM(:))*1.2 ]);
xlabel('t  [min]')
ylabel('\int_0^TC(t)dt/C(T)  [min]')
hold on
plot((startframe:length(timepoints)).*lengthFrame*numberOfFrames,xSRTM1(startframe:length(timepoints))*coeffs(1)+xSRTM2(startframe:length(timepoints))*coeffs(2),'r-');
hold off

%% Make output image

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = bindingPotentials;

bindingPotentials = image4D;

end