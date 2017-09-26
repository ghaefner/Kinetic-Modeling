function [ DVRs ] = fcnLoganK2Analysis ( pathInputImage, pathReferenceVOI, averageK2Prime, startframe, lengthFrame,pOI)
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

DVRs = single(zeros(xDim,yDim,zDim));
LoganK2Intercepts = single(zeros(xDim,yDim,zDim));
xLoganK2 = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));
yLoganK2 = single(zeros(xDim,yDim,zDim,length(timepoints)-startframe+1));

%% Calculate the TAC_ReferenceVOI and activity integral


TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, startframe, TAC_ReferenceVOI, lengthFrame);


parfor i = 1:xDim
    for j = 1:yDim
        for k = 1:zDim
            TAC = extractTACFromVoxel(image4D, [i j k]);            
            IntegralsOfActivityInVoxel = calculateIntegralsOfActivityInVoxel( timepoints,startframe,TAC,lengthFrame );
            [DVRs(i,j,k),LoganK2Intercepts(i,j,k),xLoganK2(i,j,k,:),yLoganK2(i,j,k,:)] = calcLoganK2(TAC, timepoints, startframe, IntegralsOfActivityInVoxel, IntegralsOfActivityInReferenceRegion, averageK2Prime, TAC_ReferenceVOI);
            
        end
    end
end
% Eliminate unphysiological values
%DVRs = DVRs.*double(DVRs < 20);

%% Plot data for ROI
xData = zeros(1,size(xLoganK2,4));
yData = zeros(1,size(yLoganK2,4));

idxj = 1:size(xLoganK2,4);
xData(idxj) = xLoganK2(pOI(1),pOI(2),pOI(3),idxj);
yData(idxj) = yLoganK2(pOI(1),pOI(2),pOI(3),idxj);

disp(xData);
disp(yData);

figure(1);

plot(xData((startframe:length(timepoints))),yData(startframe:length(timepoints)),'b*');
ylabel('\int_0^T C(t)dt / C(T)  [min]')
xlabel('(\int_0^TC_{ref}(t)dt+C_{ref}(T)/k2_{ref})/C(T)  [min]')
hold on
plot((xData(startframe:length(timepoints))),xData(startframe:length(timepoints))*DVRs(pOI(1),pOI(2),pOI(3))+LoganK2Intercepts(pOI(1),pOI(2),pOI(3)),'r-');
hold off


%% Make output image

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = DVRs;

DVRs = image4D;


end

