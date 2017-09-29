function [ ] = relativeImages( pathImagesToProcessFolder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Create output directory
pathImagesToProcessFolder = [pathImagesToProcessFolder, '/'];
pathOutputFolder = [pathImagesToProcessFolder, 'relativ/'];
mkdir(pathOutputFolder);

%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'*.nii'));
numberOfFiles=length(subj);

%% Loop over all files and reduces images

for FileNumber = 1:numberOfFiles
    currentImagePath = [pathImagesToProcessFolder subj(FileNumber).name];
    
    image4D = load_nii(currentImagePath);
    currentImage = image4D.img;
    
    currentImage = currentImage./(max(currentImage(:)));

    % Save new image
    image4D.hdr.dime.dim(1) = 3;
    image4D.hdr.dime.dim(5) = 1;
    image4D.img = currentImage;

    currentImage = image4D;
    
    save_nii(currentImage, [pathOutputFolder, 'rel_', subj(FileNumber).name]);

end
  
disp('Done.');

end

