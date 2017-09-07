function [ meanSlopeROI, ROI ] = calcSlopeROI ( pathOutputFolder, pixelOfInterest)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%% Get output images

images = dir(strcat(pathOutputFolder, '*.nii'));
numberOfImages=length(images);


%% Define region of interest ROI
sizeROI = 5;
ROI = zeros(length(pixelOfInterest),2*sizeROI+1);

for j = 1:length(pixelOfInterest)
    for k = 1:(2*sizeROI+1)
        ROI(j,k) = pixelOfInterest(j) + (k - (sizeROI + 1));
    end
end


%% Calculate the mean of the patlak slopes in the ROI from the output-files
meanSlopeROI = zeros(numberOfImages,1);

for j = 1:numberOfImages
    slopeImageNii = load_nii([pathOutputFolder images(j).name]);
    slopeImage = slopeImageNii.img;
    
    for k = 1:(2*sizeROI+1)
        meanSlopeROI(j) = meanSlopeROI(j) + abs(slopeImage(ROI(1,k),ROI(2,k),ROI(3,k)))/nnz(slopeImage(ROI(1,k),ROI(2,k),ROI(3,k))); 
        
        %(2*sizeROI+1) -- Hier bin ich mir nicht sicher, ob nur nnz
        % elements oder allg. 2*sizeROI+1 für den Mittelwert!
    end
    
end

disp(meanSlopeROI);

end

