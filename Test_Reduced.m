%% Environment

pathInputImage = '/media/mmni_raid2/Filesystem/ghaefner/Kinetic-Modeling/testImages/s5wrkfors-h1430p-dopa-2015.6.18.13.37.13_em_3D.nii';
pathOutputFolder = '/media/mmni_raid2/Filesystem/ghaefner/Kinetic-Modeling/testImages/';

reducedImageNii = getReducedImage(pathInputImage);

save_nii(reducedImageNii, [pathOutputFolder 'reduced_s5wrkfors-h1430p-dopa-2015.6.18.13.37.13_em_3D.nii']);
