%% Environment

pathImagesToProcessFolder = '/media/mmni_raid2/Filesystem/ghaefner/Kinetic-Modeling/testImages/';
pathOutputFolder = [pathImagesToProcessFolder, 'Patlak/'];
pathReferenceVOI = [pathImagesToProcessFolder, '../ReferenceVOI/AAL_occipital_49-54_79x95x78.nii'];
hold on
% Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

% Get reference imagecoordinates = [40,50,70];
referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

%% Loop over all files

ROI = [ 20 40 60 ]; % Set a random voxel for test
timepoints = 0:9;
timeInterval = 10; % min

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
    currentImage = load_nii(currentImagePath);
 
    TAC_ReferenceVOI = extractTACFromReferenceRegions(currentImage,referenceVOI);
    TAC = extractTACFromVoxel(currentImage,ROI);
    TAC_ReferenceVOI = [0 TAC_ReferenceVOI];
    TAC = [0 TAC];
    %ratioTAC = TAC/TAC_ReferenceVOI;
    
    plot(timepoints,TAC,'*');
    
end