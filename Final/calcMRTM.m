function [ BP, k2Prime, chiSquare, coeffs, x1,x2, y ] = calcMRTM( timepoints, startFrame, TAC, TAC_ReferenceVOI, IntegralsOfActivityInRegion, IntegralsOfActivityInVoxel )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in arrays 
lengthTimepoints = length(timepoints);
x = zeros(lengthTimepoints,3);
y = zeros(lengthTimepoints,1);

% Use 
id = startFrame:lengthTimepoints;

x(id-startFrame+1,1) = IntegralsOfActivityInRegion(id)./TAC(id);
x(id-startFrame+1,2) = TAC_ReferenceVOI(id)./TAC(id);
x(id-startFrame+1,3) = 1;
y(id-startFrame+1) = IntegralsOfActivityInVoxel(id)./TAC(id);

x1 = x(:,1);
x2 = x(:,2);

%% Use 'regress' operation for multilinear regression
[coeffs, ~, res] = regress(y,x);
chiSquare = sum(res.^2)/((sum(y(:)))*(nnz(y)-1));

%% Output values
DVR = abs(coeffs(1));
k2Prime = DVR / abs(coeffs(2)); % [ 1/min ]
BP = DVR - 1.;
