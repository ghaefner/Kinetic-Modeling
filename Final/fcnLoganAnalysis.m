function [ LoganSlopes ] = fcnLoganAnalysis ( pathInputImage, pathReferenceVOI, startframe, lengthFrame, pOI )
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
timepoints = 1:size(image4D.img,4);

LoganSlopes = single(zeros(xDim,yDim,zDim));
LoganIntercepts = single(zeros(xDim,yDim,zDim));
xLogan = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
yLogan = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));

%% Calculate the TAC_ReferenceVOI and activity integral

TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, startframe, TAC_ReferenceVOI, lengthFrame);


parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim
            
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints,1,TAC,lengthFrame );
            [LoganSlopes(i,j,k),LoganIntercepts(i,j,k),xLogan(i,j,k,:),yLogan(i,j,k,:)] = calcLogan(timepoints, startframe, TAC, IntegralsOfActivityInVoxel, IntegralsOfActivityInReferenceRegion);
            
        end
    end
end

disp(xLogan(pOI(1),pOI(2),pOI(3),:));

%% Plot data for ROI
xData = zeros(1,size(xLogan,4));
yData = zeros(1,size(yLogan,4));

idxj = 1:size(xLogan,4);
xData(idxj) = xLogan(pOI(1),pOI(2),pOI(3),idxj);
yData(idxj) = yLogan(pOI(1),pOI(2),pOI(3),idxj);

figure(1);

plot(xData(startframe:length(timepoints)),yData(startframe:length(timepoints)),'b*');
axis([0 max(xData(:))*1.3 0 max(yData(:))*1.3 ]);
disp(xData);
%disp(yData);
xlabel('\int_0^T C_{ref}(t)dt / C(T)  [min]')
ylabel('\int_0^TC(t)dt/C(T)  [min]')
hold on
plot(xData(startframe:length(timepoints)),xData(startframe:length(timepoints))*LoganSlopes(pOI(1),pOI(2),pOI(3))+LoganIntercepts(pOI(1),pOI(2),pOI(3)),'r-');
hold off


%% Make output image
image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = LoganSlopes;

LoganSlopes = image4D;


end

