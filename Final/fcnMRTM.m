function [ bindingPotentials, averageK2Prime, stDevK2Prime, chiSquareROI ] = fcnMRTM( pathInputImage, pathReferenceVOI, startframe, lengthFrame,pOI,numberOfFrames )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%% Load image and referenceVOI
image4D = load_nii(pathInputImage);

referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

% Get dimensions
sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);
xDim = sizeInputImage(1);
yDim = sizeInputImage(2);
zDim = sizeInputImage(3);

timepoints = 1:numberOfFrames:(floor(size(image4D.img,4)/numberOfFrames)*numberOfFrames);

%% Calculate reference values
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI, numberOfFrames );
IntegralsOfActivityInRegion = calculateIntegralsOfActivityInReferenceRegion(startframe, TAC_ReferenceVOI, lengthFrame, numberOfFrames);

bindingPotentials = single(zeros(xDim,yDim,zDim));
k2Primes = single(zeros(xDim,yDim,zDim));
%% Fill every voxel and calculate model parameters
parfor i = 1:xDim
    warning('off','all');
    for j = 1:yDim
        for k = 1:zDim            
            TAC = extractTACFromVoxel(image4D, [i j k], numberOfFrames);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( startframe,TAC, lengthFrame, numberOfFrames );
            [bindingPotentials(i,j,k), k2Primes(i,j,k)] = calcMRTM(timepoints,startframe,TAC,TAC_ReferenceVOI,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);        
        end
    end
end

%% Output values
% Weight k2Primes inside referenceVOI
k2PrimesReference = k2Primes.*referenceVOI;

% Using nan function to calculate means
averageK2Prime = nanmean(k2PrimesReference(:));
stDevK2Prime = nanstd((k2PrimesReference(:)),1)*sqrt(1/(length(k2PrimesReference(:))-1));

%% Plot image for ROI
% Get data
coeffs = zeros(3,1);
xMRTM1 = zeros(length(timepoints)-startframe+1,1);
xMRTM2 = zeros(length(timepoints)-startframe+1,1);
yMRTM = zeros(length(timepoints)-startframe+1,1);

TAC_ROI = extractTACFromVoxel(image4D, [pOI(1), pOI(2), pOI(3)], numberOfFrames);            
IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( startframe,TAC_ROI,lengthFrame,numberOfFrames );
[~,~,chiSquareROI,coeffs(:),xMRTM1(:),xMRTM2(:),yMRTM(:)] = calcMRTM(timepoints,startframe,TAC_ROI,TAC_ReferenceVOI,IntegralsOfActivityInRegion,IntegralsOfActivityInVoxel);        

% Plot
figure(1);

plot((startframe:length(timepoints)).*lengthFrame*numberOfFrames,yMRTM(startframe:length(timepoints)),'b*');
axis([0 (max(timepoints(:))+1)*lengthFrame*numberOfFrames 0 max(yMRTM(:))*1.2 ]);
xlabel('t  [min]')
ylabel('\int_0^TC(t)dt/C(T)  [min]')
hold on
plot((startframe:length(timepoints)).*lengthFrame*numberOfFrames,xMRTM1(startframe:length(timepoints))*coeffs(1)+xMRTM2(startframe:length(timepoints))*coeffs(2)+coeffs(3),'r-');
hold off


%% Making image

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = bindingPotentials;

bindingPotentials = image4D;

end

