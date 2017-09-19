function [ BP, k2Prime ] = calcMRTM( timepoints, startFrame, TAC, TAC_ReferenceVOI, IntegralsOfActivityInRegion, IntegralsOfActivityInVoxel )
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


%% Define the function according to the MRTM model
F = @(coeffs,time) - coeffs(1) * data(1,time) + coeffs(2) * data(2,time) - coeffs(3) * data(3,time);
initialValues = [1.,0.5,1.];

% Fitting procedure using lsqcurvefit
options=optimset('Display','off');
[coeffs] = lsqcurvefit(F,initialValues,(1:(lengthTimepoints-startFrame+1)),data(4,:),[],[],options);

%% Output values
DVR = abs(coeffs(1)/coeffs(2));
k2Prime = abs(coeffs(3)) / abs(coeffs(1)); % [ 1/min ]
BP = abs(DVR - 1.);
