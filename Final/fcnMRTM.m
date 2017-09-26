function [ bindingPotentials, averageK2Prime, stDevK2Prime, chiSquareROI ] = fcnMRTM( pathInputImage, pathReferenceVOI, startframe, lengthFrame,pOI )
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
k2Primes = single(zeros(xDim,yDim,zDim));
chiSquare = single(zeros(xDim,yDim,zDim));
xMRTM1 = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
xMRTM2 = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
yMRTM = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
coeffs = single(zeros(xDim,yDim,zDim,3));

%% Calculate reference values
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, startframe, TAC_ReferenceVOI, lengthFrame);

%% Fill every voxel and calculate model parameters
parfor i = 1:xDim
    warning('off','all');
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints,1,TAC, lengthFrame );
            [bindingPotentials(i,j,k), k2Primes(i,j,k),chiSquare(i,j,k),coeffs(i,j,k,:),xMRTM1(i,j,k,:),xMRTM2(i,j,k,:),yMRTM(i,j,k,:)] = calcMRTM(timepoints,startframe,TAC,TAC_ReferenceVOI,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);        
        end
    end
end

%% Output values
% Weight k2Primes inside referenceVOI
k2PrimesReference = k2Primes.*referenceVOI;

% Using nan function to calculate means
averageK2Prime = nanmean(k2PrimesReference(:));
stDevK2Prime = nanstd((k2PrimesReference(:)),1)*sqrt(1/(length(k2PrimesReference(:))-1));
chiSquareROI = chiSquare(pOI(1),pOI(2),pOI(3));

%% Plot image for ROI
xData1 = zeros(size(xMRTM1,4));
xData2 = zeros(size(xMRTM2,4));
yData = zeros(size(yMRTM,4));

idxj = 1:size(xMRTM1,4);
xData1(idxj) = xMRTM1(pOI(1),pOI(2),pOI(3),idxj);
xData2(idxj) = xMRTM2(pOI(1),pOI(2),pOI(3),idxj);
yData(idxj) = yMRTM(pOI(1),pOI(2),pOI(3),idxj);

figure(1);

plot((startframe:length(timepoints)).*lengthFrame,yData(startframe:length(timepoints)),'b*');
xlabel('t  [min]')
ylabel('\int_0^TC(t)dt/C(T)  [min]')
hold on
plot((startframe:length(timepoints)).*lengthFrame,xData1(startframe:length(timepoints))*coeffs(pOI(1),pOI(2),pOI(3),1)+xData2(startframe:length(timepoints))*coeffs(pOI(1),pOI(2),pOI(3),2)+coeffs(pOI(1),pOI(2),pOI(3),3),'r-');
hold off


%% Making image

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = bindingPotentials;

bindingPotentials = image4D;

end

