function [ TAC_ReferenceVOI ] = extractTACFromReferenceRegions( image4D, referenceVOI )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Compare sizes of ReferenceVOI and image4D
sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);
if ~isequal(size(referenceVOI) , sizeInputImage) %tilde ~ means NOT
    TAC_ReferenceVOI =1;
    disp('Dimesions of image4D and reference VOI are not equal. abort.');
    return
else
    
    disp('Dimesions of image4D and reference VOI are  equal. OK!.');
end

TAC_ReferenceVOI = zeros(1,size(image4D.img,4));

%% Run through time frames
% Calculate the reference image and sum it up for the TAC_ReferenceVOI

for i = 1:size(image4D.img,4)

    currentImage = squeeze(image4D.img(:,:,:,i)).*referenceVOI; %Elementweise Multiplikation mit referenceVOI
    sumOfVOI = sum(currentImage(:));
    TAC_ReferenceVOI(i) = sumOfVOI / nnz(referenceVOI); %non-zero elements of referenceVOI
end
    
clear currentImage;

end

