% This function reads in the volumetric output of qchem. It doesn't compress it.
% It retains its original Nx(3+M) structure. 
% It's literally the same as readESP and is created for convenience
function y = readQCVol(filePath)
	y = readESP(filePath);
end