function [ Patlak_slope, Patlak_intercept ] = calculateKi(TAC, timepoints, startFrame, TACFromReferenceRegion, IntegralsOfActivityInReferenceRegion)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


for i = startFrame:length(timepoints)
    %disp(i);
    y(i-startFrame+1) = TAC(i)/TACFromReferenceRegion(i);
    x(i-startFrame+1) = IntegralsOfActivityInReferenceRegion(i)/TACFromReferenceRegion(i);
    
end


% Apply linear model
p = polyfit(x,y,1);
% p(2) is the intercept, p(1) is the slope


Patlak_slope = p(1) ;
Patlak_intercept = p(2);

% Plotting of linear regression
%
% plot(x,y,'*');
% axis([0 max(x)*1.2 0 max(y)*1.2]);
% hold on
% plot(x, x*Patlak_slope+Patlak_intercept);
% hold off

end

