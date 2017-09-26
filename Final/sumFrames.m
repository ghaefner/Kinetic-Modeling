function [ TACsum ] = sumFrames( TAC, numberOfFrames )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lengthTimepoints = length(TAC);
reducedLength = floor(lengthTimepoints/numberOfFrames);

TACsum = zeros(1,reducedLength);

for j = 1:numberOfFrames:reducedLength*numberOfFrames
    TACsum((j+numberOfFrames-1)/numberOfFrames) = sum(TAC(j:j+numberOfFrames-1));
end

end

