function [ meanBPs,chiSquareROIs,averageK2s ] = SRTM( pathImagesToProcessFolder, pathReferenceVOI, pixelOfInterest, sizeROI, startframe, lengthFrame, numberOfFrames )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Environment

pathImagesToProcessFolder = [pathImagesToProcessFolder, '/'];
pathOutputFolder = [pathImagesToProcessFolder, 'SRTM/'];

% Create output directory
mkdir(pathOutputFolder);

% Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);


averageK2s = zeros(numberOfFiles);
chiSquareROIs = zeros(numberOfFiles);


%% Loop over all files

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
 
    [currentBindingPotentialNii,chiSquareROIs(FileNumber),averageK2s(FileNumber)] = fcnSRTM(currentImagePath,pathReferenceVOI, startframe, lengthFrame, pixelOfInterest, numberOfFrames);
    
    %% Save Output
    save_nii(currentBindingPotentialNii, [pathOutputFolder 'BP_SRTM_' subj(FileNumber).name]);
        
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);


end

%% Calculate BP ROI

meanBPs = calcSlopeROI(pathOutputFolder,pixelOfInterest,sizeROI);


end

