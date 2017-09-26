function [ Logan_slope, Logan_intercept,x,y ] = calcLogan( timepoints, startFrame, TAC, IntegralsOfActivityInReferenceRegion, IntegralsOfActivityInVoxel )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in x and y arrays (i.e. generating the logan plot)
lengthTimepoints = length(timepoints);

x = zeros(lengthTimepoints-startFrame,1);
y = zeros(lengthTimepoints-startFrame,1);

id = startFrame:lengthTimepoints;
y(id-startFrame+1) = IntegralsOfActivityInVoxel(id)./TAC(id);
x(id-startFrame+1) = IntegralsOfActivityInReferenceRegion(id)./TAC(id);

%% Linear Fit to obtain logan parameters
b = regress(y,[x ones(lengthTimepoints,1)]);
%p2 = [ones(length(x),1) ,reshape(x,length(x),1)] \ reshape(y,length(y),1);
Logan_slope = b(1);
Logan_intercept= b(2);

end

