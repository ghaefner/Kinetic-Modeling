function [ BP, k2Prime, chiSquare ] = calcMRTM( timepoints, startFrame, TAC, TAC_ReferenceVOI, IntegralsOfActivityInRegion, IntegralsOfActivityInVoxel )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in arrays 
lengthTimepoints = length(timepoints);
xValues = zeros(lengthTimepoints,3);
yValues = zeros(lengthTimepoints,1);

% Use 
id = startFrame:lengthTimepoints;

xValues(id-startFrame+1,1) = IntegralsOfActivityInRegion(id)./TAC(id);
xValues(id-startFrame+1,2) = TAC_ReferenceVOI(id)./TAC(id);
xValues(id-startFrame+1,3) = 1;
yValues(id-startFrame+1) = IntegralsOfActivityInVoxel(id)./TAC(id);


%% Use 'regress' operation for multilinear regression
[coeffs, ~, res] = regress(yValues,xValues);
chiSquare = sum(res.^2)/(sum(yValues(:)));

%% Output values
DVR = abs(coeffs(1));
k2Prime = DVR / abs(coeffs(2)); % [ 1/min ]
BP = DVR - 1.;
