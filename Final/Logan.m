function [meanSlopesROI,chiSquareROIs ] = Logan ( pathImagesToProcessFolder, pathReferenceVOI, pixelOfInterest, sizeROI, startframe, lengthFrame, numberOfFrames )

tic;
%Create Output Directory
pathImagesToProcessFolder = [pathImagesToProcessFolder, '/'];
pathOutputFolder = [pathImagesToProcessFolder, 'Logan/'];
mkdir(pathOutputFolder);

%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);


chiSquareROIs = zeros(numberOfFiles,1);
%% Run through all files in the input folder

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];

    [ currentLoganSlopesNii, chiSquareROIs(FileNumber) ] = fcnLoganAnalysis(currentImagePath,pathReferenceVOI, startframe, lengthFrame,pixelOfInterest, numberOfFrames);
    
    %% Save output
    save_nii(currentLoganSlopesNii, [pathOutputFolder 'Logan_' subj(FileNumber).name]);
    
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);
    
end

disp('Done');

meanSlopesROI = calcSlopeROI(pathOutputFolder, pixelOfInterest,sizeROI);

end

