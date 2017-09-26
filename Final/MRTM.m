function [ meanBPsROI, chiSquareROIs, averageK2Primes ] = MRTM( pathImagesToProcessFolder, pathReferenceVOI, pixelOfInterest, sizeROI, startframe, lengthFrame )

tic;
%% Environment
%Create Output Directory
pathImagesToProcessFolder = [pathImagesToProcessFolder, '/'];
pathOutputFolder = [pathImagesToProcessFolder, 'MRTM/'];
pathK2Primes = [pathImagesToProcessFolder, 'k2Primes/'];

%Create Output Directory
mkdir(pathOutputFolder);
mkdir(pathK2Primes);

% Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);
% 
% Check if k2Prime file already exists and aboard
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

averageK2Primes = zeros(numberOfFiles);
stDevK2Primes = zeros(numberOfFiles);
chiSquareROIs = zeros(numberOfFiles);

for FileNumber = 1:numberOfFiles
    
    currentImagePath = [ pathImagesToProcessFolder subj(FileNumber).name];
    
    [ currentBindingPotentialNii, averageK2Primes(FileNumber), stDevK2Primes(FileNumber),chiSquareROI(FileNumber)] = fcnMRTM(currentImagePath,pathReferenceVOI, startframe, lengthFrame, pixelOfInterest);
    
    
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

%% Calculate BP ROI

meanBPsROI = calcSlopeROI(pathOutputFolder,pixelOfInterest,sizeROI);


end

