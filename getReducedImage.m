function [ reducedImage4D ] = getReducedImage( pathInputImage )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

image4Dnii = load_nii(pathInputImage);
image4D = image4Dnii.img;

maxValue = max(image4D(:));
threshold = 0.5;

reducedImage4D = double(image4D < threshold*maxValue).*image4D;

image4D.hdr.dime.dim(1) = 3;
image4D.hdr.dime.dim(5) = 1;
image4D.img = reducedImage4D;

reducedImage4D = image4D;

end

