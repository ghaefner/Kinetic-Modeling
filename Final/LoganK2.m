function [ meanSlopesROI ] = LoganK2 ( pathImagesToProcessFolder, pathReferenceVOI, pixelOfInterest, sizeROI, startframe, lengthFrame )

tic;
%Create Output Directory
pathImagesToProcessFolder = [pathImagesToProcessFolder, '/'];
pathOutputFolder = [pathImagesToProcessFolder, 'LoganK2/'];
pathK2PrimeFolder = [pathImagesToProcessFolder, 'k2Primes/'];
mkdir(pathOutputFolder);

%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

averageK2Primes = load([ pathK2PrimeFolder, 'k2Primes.txt']);
numberOfK2Primes = length(averageK2Primes);

if ~isequal(numberOfFiles,numberOfK2Primes)
    disp('ERROR: Number of files and k2 rates do not match. Check in the MRTM code. ');
    return
else
    
    disp('All averaged k2 rates are available. ');
end    

%% Run through all files in the input folder
for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
    
    currentLoganSlopesNii = fcnLoganK2Analysis(currentImagePath,pathReferenceVOI, averageK2Primes(FileNumber), startframe, lengthFrame,pixelOfInterest);
    
    %% Save output
    save_nii(currentLoganSlopesNii, [pathOutputFolder 'DVR_Logan_' subj(FileNumber).name]);
    
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);
    
end

disp('Done');

meanSlopesROI = calcSlopeROI(pathOutputFolder,pixelOfInterest,sizeROI);

end

