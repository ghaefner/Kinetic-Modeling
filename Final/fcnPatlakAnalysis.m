function [ PatlakSlopes,chiSquareROI ] = fcnPatlakAnalysis(pathInputImage, pathReferenceVOI, startframe, lengthFrame,pOI,numberOfFrames)

%% Load image and referenceVOI
image4D = load_nii(pathInputImage);

referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

% Set sizes
sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);
xDim = sizeInputImage(1);
yDim = sizeInputImage(2);
zDim = sizeInputImage(3);

timepoints = 1:numberOfFrames:(floor(size(image4D.img,4)/numberOfFrames)*numberOfFrames);

%% Calculate the TAC_ReferenceVOI and activity integral
TAC_ReferenceVOI = extractTACFromReferenceRegions(image4D, referenceVOI, numberOfFrames);
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(startframe, TAC_ReferenceVOI, lengthFrame, numberOfFrames);

%% Calculate the PatlakSlopes using calculateKi for every voxel
PatlakSlopes = single(zeros(xDim,yDim,zDim));
% PatlakIntercepts = single(zeros(xDim,yDim,zDim));
% xPatlak = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
% yPatlak = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));

parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim
            TAC = extractTACFromVoxel(image4D, [i j k], numberOfFrames);
            PatlakSlopes(i,j,k) = calcPatlak(timepoints, startframe, TAC, TAC_ReferenceVOI, IntegralsOfActivityInReferenceRegion);            
        end
    end
end

%% Plot for pixel of interest to gain a feeling fot the fit goodness
% Get data
xPatlak = single(zeros(length(timepoints)-startframe+1,1));
yPatlak = single(zeros(length(timepoints)-startframe+1,1));

TAC_ROI = extractTACFromVoxel(image4D,[pOI(1), pOI(2), pOI(3)],numberOfFrames);
[~,PatlakIntercept,xPatlak(:,1),yPatlak(:,1),chiSquareROI] = calcPatlak(timepoints,startframe,TAC_ROI,TAC_ReferenceVOI,IntegralsOfActivityInReferenceRegion);

figure(1);

% Plot
plot(xPatlak(:),yPatlak(:),'b*');
axis([0 max(xPatlak(:))*1.2 0 max(yPatlak(:))*1.2]);
xlabel('\int_0^T C_{ref}(t)dt / C_{ref}(T)  [min]')
ylabel('C(T)/C_{ref}(T)')
hold on
plot(xPatlak(:),xPatlak(:)*PatlakSlopes(pOI(1),pOI(2),pOI(3))+PatlakIntercept,'r-');
hold off


%% Make slope image
image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = PatlakSlopes;

PatlakSlopes = image4D;



end

