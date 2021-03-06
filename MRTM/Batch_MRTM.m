tic;

%% Environment

pathImagesToProcessFolder = '/media/mmni_raid2/Filesystem/ghaefner/Kinetic-Modeling/images/';
pathOutputFolder = [pathImagesToProcessFolder, 'MRTM/'];
pathReferenceVOI = [pathImagesToProcessFolder, '../ReferenceVOI/AAL_occipital_49-54_79x95x78.nii'];
pathK2Primes = [pathImagesToProcessFolder, 'k2Primes/'];

%Create Output Directory
mkdir(pathOutputFolder);
mkdir(pathK2Primes);

% Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

% Get reference image
referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

%% Check if k2Prime file already exists and aboard, commented for testing purposes. Isn't that bad after all.
% if exist([pathK2Primes, 'k2Primes.txt'],'file') == 2
%     disp('ERROR: k2Prime file already existing. Check in the following directory: ');
%     disp(pathK2Primes);
%     return
% end

% Write header for k2Prime file
fileK2 = fopen([pathK2Primes, 'k2Primes.txt'],'w');
fprintf(fileK2,'%s','% MRTM Calculation from');
fprintf(fileK2,'%s',['% ', date]);
fprintf(fileK2,'\n');
fprintf(fileK2,'%s','% k2Prime values given in 1/min');
fprintf(fileK2,'\n');
fileK2std = fopen([pathK2Primes, 'stdK2Primes.txt'],'w');


%% Define parameters
timepoints = 1:9;
startFrame = 3;
averageK2Primes = zeros(numberOfFiles);
stDevK2Primes = zeros(numberOfFiles);

%% Run through all of the files

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [ pathImagesToProcessFolder subj(FileNumber).name];
    currentImage = load_nii(currentImagePath);
    
    [ currentBindingPotentialNii, averageK2Primes(FileNumber), stDevK2Primes(FileNumber)] = fcnMRTM(currentImagePath,pathReferenceVOI, timepoints, startFrame);
    
    
    %% Save Output
    save_nii(currentBindingPotentialNii, [pathOutputFolder 'BP_MRTM_' subj(FileNumber).name]);
    fprintf(fileK2,'%.5f',averageK2Primes(FileNumber));
    fprintf(fileK2,'\n');
    fprintf(fileK2std,'%.5f',stDevK2Primes(FileNumber));
    fprintf(fileK2std,'\n');
    
    disp(['Processed ' num2str(FileNumber) ' of ' num2str(numberOfFiles) ' Files. ' subj(FileNumber).name]);
        
end
toc;
fclose('all');