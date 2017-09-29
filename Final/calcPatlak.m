function [ Patlak_slope, Patlak_intercept,x,y,chiSquare ] = calcPatlak(timepoints, startFrame,TAC, TAC_ReferenceVOI, IntegralsOfActivityInReferenceRegion)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%% Define and fill in x and y arrays (i.e. generating the patlak plot)
lengthTimepoints = length(timepoints);

x = zeros(lengthTimepoints-startFrame,1);
y = zeros(lengthTimepoints-startFrame,1);

id = startFrame:lengthTimepoints;
y(id-startFrame+1) = TAC(id)./TAC_ReferenceVOI(id);
x(id-startFrame+1) = IntegralsOfActivityInReferenceRegion(id)./TAC_ReferenceVOI(id);

% Apply linear model using matrix operations... this is is a bit faster...
% here p2(1) is the intercept, p2(2) is the slope
%p2 = [ones(length(x),1) ,reshape(x,length(x),1)] \ reshape(y,length(y),1);
[coeffs,~,res] = regress(y,[x ones(length(x),1)]);
chiSquare = sum(res(:).^2)/(sum(y(:))*(nnz(y)-1));

Patlak_slope = coeffs(1);
Patlak_intercept = coeffs(2);


%% Plotting of linear regression
% 
%  plot(x(1,:),y(1,:),'*');
%  axis([0 max(x)*1.2 0 max(y)*1.2]);
%  hold on
%  plot(x, x*Patlak_slope+Patlak_intercept);
%  hold off

end

