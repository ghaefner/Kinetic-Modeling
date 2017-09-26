function [ IntegralsOfActivityInVoxel ] = calculateIntegralsOfActivityInVoxel( startFrame,TAC, lengthFrame, numberOfFrames )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

timepoints = 1:length(TAC);
lengthFrame = lengthFrame*numberOfFrames;

% Add zeros both to TAC and timepoints to include the origin in the
% Time-Activity Curve
timepoints = [0 timepoints];
TAC = [0 TAC];

%lengthFrame = 10;

% The loop needs to start with i=(startFrame+1) because the first value in the vectors
% timepoints and TACFromReferenceRegion is the (0,0)-pair that was added
% artificially

IntegralsOfActivityInVoxel = zeros(1,length(timepoints)-1);

for i=(startFrame+1):length(timepoints)

    IntegralsOfActivityInVoxel(i-1) = trapz(timepoints(1:i).*lengthFrame,TAC(1:i));

end

end

