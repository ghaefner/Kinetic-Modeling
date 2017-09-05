

% image4D
% referenceVOI

timepoints = 1:9
startframe = 4

image4D = load_nii('/home/jhammes/Desktop/jhammes/KFORS_DOPA_dyn_Normalized/smoothed5mm/s5wrkfors-h3360p-dopa-2014.12.11.13.8.21_em_3D.nii');

referenceVOInii = load_nii('/beegfs/v1/tnc_group/usr/jhammes/Atlasses/AAL/AAL_occipital_49-54_79x95x78.nii');
referenceVOI = referenceVOInii.img;


sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);


TAC_ReferenceVOI = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, 1, TAC_ReferenceVOI);

PatlakSlopes = single(zeros(sizeInputImage(1),sizeInputImage(2),sizeInputImage(3)));


parfor i = 1:79
    for j = 1:95
        for k = 1:78
            
            TAC = extractTACFromVoxel(image4D, [i j k]);
            PatlakSlopes(i,j,k) = calculateKi(TAC, timepoints, startframe, TAC_ReferenceVOI, IntegralsOfActivityInReferenceRegion);
            
        end
    end
    disp(i);
end

% PatlakSlopesNii = referenceVOInii;
% PatlakSlopesNii.img = PatlakSlopes;


PatlakSlopesNii = make_nii(PatlakSlopes, [2 2 2]);

save_nii(PatlakSlopesNii, 'testPatlakslopes_79x95x78.nii');
disp('done');