%% Environment

pathImagesToProcessFolder = '/media/mmni_raid2/Filesystem/ghaefner/Kinetic-Modeling/testImages/';
pathOutputFolder = [pathImagesToProcessFolder, 'Logan/'];
pathReferenceVOI = [pathImagesToProcessFolder, '../ReferenceVOI/AAL_occipital_49-54_79x95x78.nii'];

%Create Output Directory
mkdir(pathOutputFolder);

%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

%% Run through all files in the input folder

tic;

frames = 1:9;
startframe = 7;

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
    
    currentLoganSlopesNii = fcnLoganAnalysis(currentImagePath,pathReferenceVOI, startframe, frames);
    
    %% Save output
    save_nii(currentLoganSlopesNii, [pathOutputFolder 'Logan_' subj(FileNumber).name]);
    
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);
    
end

disp('Done');

toc;

%% Calculate the means of patlak slopes and write them into a File
pixel = [50,25,40];
calcSlopeROI(pathOutputFolder, pixel);
