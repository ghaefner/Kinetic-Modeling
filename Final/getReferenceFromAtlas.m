function [ referenceVOIreduced ] = getReferenceFromAtlas ( tracerIndex, pathReferenceVOI, pathReferenceVOIReduced )

referenceVOInii = load_nii(pathReferenceVOI);
referenceVOI = referenceVOInii.img;
referenceVOIreduced = zeros(size(referenceVOI));

% Convert to integer
referenceVOI = round(referenceVOI);

for j = 1:length(tracerIndex)
    referenceVOIreduced = referenceVOIreduced + double(referenceVOI == tracerIndex(j));
end

%% Test for nonzero elements

if (nnz(referenceVOIreduced) == 0)
    disp('ERROR. No valid reference region selected. Choose another index.');
    return
end

%disp(nnz(referenceVOIreduced));

%% Save new reference VOI output
referenceVOInii.hdr.dime.dim(1) = 3;
referenceVOInii.hdr.dime.dim(5) = 1;
referenceVOInii.img = referenceVOIreduced;

referenceVOIreduced = referenceVOInii;

save_nii(referenceVOIreduced, pathReferenceVOIReduced);






end

