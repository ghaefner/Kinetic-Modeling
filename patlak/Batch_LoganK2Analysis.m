tic;
%% Environment

pathImagesToProcessFolder = '/media/mmni_raid2/Filesystem/ghaefner/Kinetic-Modeling/images/';
pathOutputFolder = [pathImagesToProcessFolder, 'LoganK2/'];
pathReferenceVOI = [pathImagesToProcessFolder, '../ReferenceVOI/AAL_occipital_49-54_79x95x78.nii'];
pathK2PrimeFolder = [pathImagesToProcessFolder, 'k2Primes/'];

% Create Output Directory
mkdir(pathOutputFolder);

% Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

%% Define parameters
frames = 1:9;
startframe = 4;

%% Get averageK2Primes from MRTM calculation
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
    
    currentLoganSlopesNii = fcnLoganK2Analysis(currentImagePath,pathReferenceVOI, averageK2Primes(FileNumber), startframe, frames);
    
    %% Save output
    save_nii(currentLoganSlopesNii, [pathOutputFolder 'Logan_K2_' subj(FileNumber).name]);
    
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);
    
end

disp('Done');

toc;

%% Calculate the means of patlak slopes and write them into a File
 pixel = [40,45,40];
 
 meanSlopesROI = calcSlopeROI(pathOutputFolder, pixel);
 disp(meanSlopesROI);

