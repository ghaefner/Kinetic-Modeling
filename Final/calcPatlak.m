function [ Patlak_slope, Patlak_intercept,x,y ] = calcPatlak(timepoints, startFrame,TAC, TAC_ReferenceVOI, IntegralsOfActivityInReferenceRegion)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in x and y arrays (i.e. generating the patlak plot)
lengthTimepoints = length(timepoints);

x = zeros(1,lengthTimepoints-startFrame);
y = zeros(1,lengthTimepoints-startFrame);

id = startFrame:lengthTimepoints;
y(id-startFrame+1) = TAC(id)./TAC_ReferenceVOI(id);
x(id-startFrame+1) = IntegralsOfActivityInReferenceRegion(id)./TAC_ReferenceVOI(id);

% Apply linear model using matrix operations... this is is a bit faster...
% here p2(1) is the intercept, p2(2) is the slope
p2 = [ones(length(x),1) ,reshape(x,length(x),1)] \ reshape(y,length(y),1);
Patlak_slope = p2(2);
Patlak_intercept = p2(1);


%% Plotting of linear regression
% 
%  plot(x(1,:),y(1,:),'*');
%  axis([0 max(x)*1.2 0 max(y)*1.2]);
%  hold on
%  plot(x, x*Patlak_slope+Patlak_intercept);
%  hold off

end

