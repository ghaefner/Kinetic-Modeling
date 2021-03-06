function [ BP, k2 ] = calcSRTM( timepoints, startFrame, TAC, IntegralsOfActivityInRegion, IntegralsOfActivityInVoxel)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in arrays
lengthTimepoints = length(timepoints);
xValues = zeros(lengthTimepoints,2);
yValues = zeros(lengthTimepoints,1);

id = startFrame:lengthTimepoints;

xValues(id-startFrame+1,1) = IntegralsOfActivityInRegion(id);
xValues(id-startFrame+1,2) = TAC(id);
yValues(id-startFrame+1) = IntegralsOfActivityInVoxel(id);

%% Use 'regress' operation for multilinear regression
coeffs = regress(yValues,xValues);

BP = coeffs(1) -1;
k2 = -coeffs(1)/coeffs(2);

end

