function [ BP ] = calcSRTM_old( timepoints, startFrame, TAC, TAC_ReferenceVOI )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in arrays
lengthTimepoints = length(timepoints);
data = zeros(2,lengthTimepoints-startFrame+2);

for j = startFrame:lengthTimepoints
    data(1,j-startFrame+2) = TAC(j);
    data(2,j-startFrame+2) = TAC_ReferenceVOI(j);
end

%% Define the function according to the SRTM model

F = @(coeffs,time) coeffs(1)*data(1,time) + coeffs(2) * conv(data(time),exp(-coeffs(3)*time),'same');
initialValues = [0.9,5.,0.2];

% Fitting procedure using lsqcurvefit
options=optimset('Display','off');
[coeffs] = lsqcurvefit(F,initialValues,(1:(lengthTimepoints-startFrame+2)),data(2,:),[],[],options);

%coeffs(1) = coeffs(1) * 1;
% yData = coeffs(1)*data(1,timepoints+1) + coeffs(2) * conv(data(timepoints+1),exp(-coeffs(3)*timepoints*10),'same');
%% Plot
%  figure(1)
%  xlabel('time [min]');
%  ylabel('Tissue concentration [kBq/ml]');
%  hold on;
%  plot(timepoints.*10,data(2,:),'r+');
%  plot(timepoints.*10,yData,'b-');



%% Output values
            
R1 = coeffs(1);
k2 = coeffs(2) + R1 * coeffs(3);
BP = (k2/coeffs(3))-1;

%disp(abs(BP));
