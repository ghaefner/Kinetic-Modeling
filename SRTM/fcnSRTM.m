function [ BP_array ] = fcnSRTM( pathInputImage,pathReferenceVOI, timepoints)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Load image and referenceVOI
image4D = load_nii(pathInputImage);

referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;

sizeInputImage=size(image4D.img);
sizeInputImage=sizeInputImage(1:3);

%% Calculate the TAC_ReferenceVOI
TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI);
BP_array = zeros(79,95,78);

%% Loop over every voxel:
for i = 1:79
    for j = 1:95
        for k = 1:78
                TAC = extractTACFromVoxel(image4D,[i j k]);
            
            % ds-Function for the fitting defined in the loop
                cTissue = @(x) C(1)*TAC_ReferenceVOI(x+1) + C(2) * conv(TAC_ReferenceVOI(x+1),exp(-C(3)*x.*10),'same');
                %function [ ds ] = dsSRTM( C )
                %cTissue = C(1) * TACReference(timepoints + 1) + C(2) * conv(TACReference(timepoints +1),exp(-C(3)*timepoints.*10),'same');
                %ds = (cTissue-TAC).^2;
                %ds = sum(ds);
                %end
                ds = (cTissue-TAC).^2;
                ds = sum(ds);
            startValues = [double(-0.001),double(3.5),double(47.)];
            C = fminsearch(@dsSRTM,startValues);
            
            BP_array(i,j,k) = (C(2)+C(1)*C(3))/C(3) - 1;
%cTissue = C(1) * TACReference(timepoints + 1) + C(2) * conv(TACReference(timepoints +1),exp(-C(3)*timepoints*10),'same');

            %% For the record: the fit parameters are correlated as such to the model parameters
            
            %R1 = C(1);
            %k2 = C(2) + C(1) * C(3);
            %BP = (k2/C(3))-1;
        end
        
    end
end
