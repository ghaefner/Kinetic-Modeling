function [ K ] = calcPatlak( timepoints, startFrame, TAC, TAC_ReferenceVOI, IntegralsOfActivityInRegion )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill array
lengthTimepoints = length(timepoints);
x1 = zeros(1,lengthTimepoints-startFrame+1);
x2 = zeros(1,lengthTimepoints-startFrame+1);
y = zeros(1,lengthTimepoints-startFrame+1);

for j = startFrame:lengthTimepoints
    x1(j-startFrame+1) = IntegralsOfActivityInRegion(j);
    x2(j-startFrame+1) = TAC_ReferenceVOI(j);
    y(j-startFrame+1) = TAC(j);
    
end


%% Define the function according to the patlak model
F = @(coeffs,time) coeffs(1) * x1(1,time) + coeffs(2) * x2(1,time);
initialValues = [4.,0.03];

% Fitting procedure using lsqcurvefit
options=optimset('Display','off');
[coeffs] = lsqcurvefit(F,initialValues,(1:(lengthTimepoints-startFrame+1)),y(1,:),[],[],options);

%% Output values
%VOD = coeffs(1);
K = coeffs(2);

end

