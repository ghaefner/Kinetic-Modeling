%% Script for plotting a convolution

% TAC inpus
TAC = [0,2.4506,3.4727,4.7564,3.5648,3.0071,3.1603,2.6018,2.4534,1.9632];
TAC_ReferenceVOI = [0.2,0.6,0.7,0.8,0.6,0.7,0.5,0.6,0.5,0.1];

% Coefficients for the fit
alpha = 0.05;
k_2 = 0.025;
R_1 = 0.12;

% Fill in x and y values

timepoints = 1:9;

x = [0 timespoints];
y = R_1 * TAC_ReferenceVOI + conv((k_2 - R_1*alpha)*TAC_ReferenceVOI,exp(-alpha*timepoints),'same');

plot(x,y)