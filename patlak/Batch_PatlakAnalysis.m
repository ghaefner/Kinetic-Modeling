%% Environment

pathImagesToProcessFolder = '/home/jhammes/Desktop/jhammes/KFORS_DOPA_dyn_Normalized_2017/smoothed5mm/';
pathOutputFolder = [pathImagesToProcessFolder 'Patlak/'];
pathReferenceVOI = '/beegfs/v1/tnc_group/usr/jhammes/Atlasses/AAL/AAL_occipital_49-54_79x95x78.nii';

%Create Output Directory
mkdir(pathOutputFolder);

%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

%% Run through all files in the input folder

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
    
    currentPatlakSlopesNii = fcnPatlakAnalysis(currentImagePath,pathReferenceVOI, 4, 1:9);
    
    %% Save output
    save_nii(currentPatlakSlopesNii, [pathOutputFolder 'Ki_' subj(FileNumber).name] );
    
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);
    
end

disp('Done');