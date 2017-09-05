

% image4D
% referenceVOI
 timepoints = 1:9;
 startframe = 4;

image4D = load_nii('testImages/TestEcat_rsl.nii');
referenceVOI_nifti = load_nii('testImages/TestEcat_rsl_times_0_plus_TestEcat_rsl_VOI.nii');
referenceVOI = referenceVOI_nifti.img;

sizeInputImage = size(image4D.img);
sizeInputImage = sizeInputImage(1:3);


TAC_ReferenceVOI  = extractTACFromReferenceRegions( image4D, referenceVOI );
IntegralsOfActivityInReferenceRegion = calculateIntegralsOfActivityInReferenceRegion(timepoints, 1, TAC_ReferenceVOI);


parfor i = 1:200
    for j = 1:200
        for k = 1:200
            
            TAC = extractTACFromVoxel(image4D, [i j k]);
            PatlakSlopes(i,j,k) = calculateKi(TAC, timepoints, 4, TAC_ReferenceVOI, IntegralsOfActivityInReferenceRegion);
            
        end
    end
    disp(i);
end
save_nii(make_nii(PatlakSlopes), 'testPatlakslopes.nii')