function [ ds ] = dsSRTM( C )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


cTissue = C(1) * TACReference(timepoints + 1) + C(2) * conv(TACReference(timepoints +1),exp(-C(3)*timepoints.*10),'same');


ds = (cTissue-TAC).^2;
ds = sum(ds);


end

