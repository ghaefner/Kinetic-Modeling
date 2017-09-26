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
timepoints = 1:size(image4D.img,4);

bindingPotentials = single(zeros(xDim,yDim,zDim));
k2s = single(zeros(xDim,yDim,zDim));
chiSquare = single(zeros(xDim,yDim,zDim));
xSRTM1 = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
xSRTM2 = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
ySRTM = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
coeffs = single(zeros(xDim,yDim,zDim,2));

%% Calculate reference values
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI, numberOfFrames );
IntegralsOfActivityInRegion = calculateIntegralsOfActivityInReferenceRegion(startframe,TAC_ReferenceVOI,lengthFrame, numberOfFrames);

parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k], numberOfFrames);
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel(startframe,TAC,lengthFrame, numberOfFrames);
            [bindingPotentials(i,j,k), k2s(i,j,k), chiSquare(i,j,k), coeffs(i,j,k,:), xSRTM1(i,j,k,:), xSRTM2(i,j,k,:), ySRTM(i,j,k,:)] = calcSRTM(timepoints,startframe,TAC,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);   
        end
    end
end

%% Calculate average k2 weighting with inverse ReferenceVOI
k2nonReference = k2s.*abs(1-referenceVOI);
averageK2 = nanmean(k2nonReference(:));
chiSquareROI = chiSquare(pOI(1),pOI(2),pOI(3));

%% Plot image for ROI
xData1 = zeros(size(xSRTM1,4));
xData2 = zeros(size(xSRTM2,4));
yData = zeros(size(ySRTM,4));

idxj = 1:size(xSRTM1,4);
xData1(idxj) = xSRTM1(pOI(1),pOI(2),pOI(3),idxj);
xData2(idxj) = xSRTM2(pOI(1),pOI(2),pOI(3),idxj);
yData(idxj) = ySRTM(pOI(1),pOI(2),pOI(3),idxj);

figure(1);

plot((startframe:length(timepoints)).*lengthFrame,yData(startframe:length(timepoints)),'b*');
xlabel('t  [min]')
ylabel('\int_0^TC(t)dt  [kBq*min/ml]')
hold on
plot((startframe:length(timepoints)).*lengthFrame,xData1(startframe:length(timepoints))*coeffs(pOI(1),pOI(2),pOI(3),1)+xData2(startframe:length(timepoints))*coeffs(pOI(1),pOI(2),pOI(3),2),'r-');
hold off



image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = bindingPotentials;

bindingPotentials = image4D;

end