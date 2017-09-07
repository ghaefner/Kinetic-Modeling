
referenceVOInii = load_nii('AAL_79x95x78.nii');
referenceVOI = referenceVOInii.img;

sumOfVOI = sum(referenceVOI(:));
TACReferenceVOI = sumOfVOI / nnz(referenceVOI);
