function [ BP, k2,chiSquare,coeffs,x1,x2,yValues ] = calcSRTM( timepoints, startFrame, TAC, IntegralsOfActivityInRegion, IntegralsOfActivityInVoxel)
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

x1 = xValues(:,1);
x2 = xValues(:,2);

%% Use 'regress' operation for multilinear regression
[coeffs,~,res] = regress(yValues,xValues);
chiSquare = sum(res(:).^2)/(sum(yValues(:))*(nnz(yValues)-1));

BP = coeffs(1) -1;
k2 = -coeffs(1)/coeffs(2);

end

