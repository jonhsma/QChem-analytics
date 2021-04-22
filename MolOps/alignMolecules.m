function aligned = alignMolecules(ref, mol)
% This function rotates 'mol' into 'ref'
% The inputs are N by 3 matrices and so are the output
	R_mat = ref'*pinv(mol');

	aligned = (R_mat*mol')';
end

	