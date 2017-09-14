function [ BP ] = calcMRTM( timepoints, startFrame, TAC, TAC_ReferenceVOI, IntegralsOfActivityInRegion, IntegralsOfActivityInVoxel )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in arrays 
lengthTimepoints = length(timepoints);
data = zeros(4,lengthTimepoints-startFrame+1);

for j = startFrame:lengthTimepoints
    data(1,j-startFrame+1) = IntegralsOfActivityInRegion(j);
    data(2,j-startFrame+1) = IntegralsOfActivityInVoxel(j);
    data(3,j-startFrame+1) = TAC_ReferenceVOI(j);
    data(4,j-startFrame+1) = TAC(j);
    
end

F = @(coeffs,time) - coeffs(1) * data(1,time) + coeffs(2) * data(2,time) - coeffs(3) * data(3,time);
initialValues = [1.,0.5,1.];

options=optimset('Display','off');
[coeffs] = lsqcurvefit(F,initialValues,(1:(lengthTimepoints-startFrame+1)),data(4,:),[],[],options);
% 
DVR = abs(coeffs(1)/coeffs(2));
% k2_prime = abs(coeffs(1)) / abs(coeffs(2));
BP = abs(DVR - 1.);