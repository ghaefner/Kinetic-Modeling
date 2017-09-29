function [meanSlopesROI,chiSquareROIs ] = Patlak( pathImagesToProcessFolder, pathReferenceVOI, pixelOfInterest, sizeROI, startframe, lengthFrame, numberOfFrames )


tic;
%Create Output Directory
pathImagesToProcessFolder = [pathImagesToProcessFolder, '/'];
pathOutputFolder = [pathImagesToProcessFolder, 'Patlak/'];
mkdir(pathOutputFolder);

%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

chiSquareROIs = zeros(numberOfFiles,1);
%% Run through all files in the input folder

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
    
    [ currentPatlakSlopesNii, chiSquareROIs(FileNumber) ] = fcnPatlakAnalysis(currentImagePath,pathReferenceVOI, startframe, lengthFrame,pixelOfInterest,numberOfFrames);
    
    %% Save output
    save_nii(currentPatlakSlopesNii, [pathOutputFolder 'K_Patlak_' subj(FileNumber).name]);
    
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);
    
end
toc;


%% Calculate the means of patlak slopes and write them into a File

meanSlopesROI = calcSlopeROI(pathOutputFolder, pixelOfInterest, sizeROI);

end

