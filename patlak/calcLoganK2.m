function [ LoganSlopeK2, LoganInterceptK2 ] = calcLoganK2( TAC,  timepoints, startFrame, IntegralsOfActivityInReferenceRegion, IntegralsOfActivityInVoxel, averageK2Prime, TAC_ReferenceVOI )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in x and y arrays (i.e. generating the logan plot)
lengthTimepoints = length(timepoints);

x = zeros(1,lengthTimepoints-startFrame);
y = zeros(1,lengthTimepoints-startFrame);


for i = startFrame:lengthTimepoints
    y(i-startFrame+1) = IntegralsOfActivityInVoxel(i)/TAC(i);
    x(i-startFrame+1) = (IntegralsOfActivityInReferenceRegion(i)+TAC_ReferenceVOI(i)*averageK2Prime)/TAC(i);
    
end

%% Linear Fit to obtain logan parameters

p2 = [ones(length(x),1) ,reshape(x,length(x),1)] \ reshape(y,length(y),1);
LoganSlopeK2 = p2(2);
LoganInterceptK2= p2(1);

end



