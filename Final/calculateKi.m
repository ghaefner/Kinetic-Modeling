function [ Patlak_slope, Patlak_intercept ] = calculateKi(TAC, timepoints, startFrame, TACFromReferenceRegion, IntegralsOfActivityInReferenceRegion)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in x and y arrays (i.e. generating the patlak plot)
lengthTimepoints = length(timepoints);

x = zeros(1,lengthTimepoints-startFrame);
y = zeros(1,lengthTimepoints-startFrame);

for i = startFrame:lengthTimepoints
    %disp(i);
    y(i-startFrame+1) = TAC(i)/TACFromReferenceRegion(i);
    x(i-startFrame+1) = IntegralsOfActivityInReferenceRegion(i)/TACFromReferenceRegion(i);
    
end

%% Linear Fit to obtain patlak parameters

% % Apply linear model using polyfit... this is slow...
% p = polyfit(x,y,1);
% % p(2) is the intercept, p(1) is the slope
% Patlak_slope = p(1) ;
% Patlak_intercept = p(2);


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

