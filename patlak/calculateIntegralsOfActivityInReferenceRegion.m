function [ IntegralsOfActivityInRegion ] = calculateIntegralsOfActivityInReferenceRegion(timepoints,startFrame,TACFromReferenceRegion)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% Add zeros both to TAC and timepoints to include the origin in the
% Time-Activity Curve
timepoints = [0 timepoints];
TACFromReferenceRegion = [0 TACFromReferenceRegion];

% The loop needs to start with i=(startFrame+1) because the first value in the vectors
% timepoints and TACFromReferenceRegion is the (0,0)-pair that was added
% artificially

IntegralsOfActivityInRegion = zeros(1,length(timepoints)-1);

for i=(startFrame+1):length(timepoints)

    IntegralsOfActivityInRegion(i-1) = trapz(timepoints(1:i),TACFromReferenceRegion(1:i));

end


end

