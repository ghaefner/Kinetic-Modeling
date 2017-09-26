tic;

%% Environment

pathImagesToProcessFolder = '/media/mmni_raid2/Filesystem/ghaefner/Kinetic-Modeling/testImages/';
pathOutputFolder = [pathImagesToProcessFolder, 'SRTM/'];
pathReferenceVOI = [pathImagesToProcessFolder, '../ReferenceVOI/AAL_occipital_49-54_79x95x78.nii'];

% Create output directory
mkdir(pathOutputFolder);

% Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

% Get reference imagecoordinates = [40,50,70];
referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

%% Define parameters
timepoints = 1:9;
startFrame = 1;

%% Loop over all files

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
    currentImage = load_nii(currentImagePath);
 
    currentBindingPotentialNii = fcnSRTM(currentImagePath,pathReferenceVOI, startframe, lengthFrame);
    
    %% Save Output
    save_nii(currentBindingPotentialNii, [pathOutputFolder 'BP_SRTM_' subj(FileNumber).name]);
        
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);

end

toc;