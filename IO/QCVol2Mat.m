% This function converts a Q-Chem volume output into a 3-D matrix
% Use the Nx, Ny, and Nz parameters you have in the input files
% Whether the Mesh matrices are going to be generated dependes on the # of
% output paramters. TODO: leave room for multiple column volumetric data in
% the future. By the way I'm converting everything to angstrom
function [y,varargout] = QCVol2Mat(QCData,npx,npy,npz)
	if nargout > 1
		flag_mesh = 1;
	else
		flag_mesh = 0;
	end
	
	idx_order = [2 1 3];

		
	if size(QCData,2)> 4
		y = zeros([npz npy npx size(QCData,2)-3]);
		n_psi = (0.529^1.5);
		for jj = 1 : size(QCData,2)-3
			y(:,:,:,jj) = permute(reshape(QCData(:,jj+3),npz,npy,npx),idx_order)/n_psi;
		end
	else
		y = permute(reshape(QCData(:,4),npz,npy,npx),idx_order)/(0.529^3);
	end
	
	
	if flag_mesh
		Z = permute(reshape(QCData(:,3),npz,npy,npx),idx_order)*0.529;
		Y = permute(reshape(QCData(:,2),npz,npy,npx),idx_order)*0.529;
		X = permute(reshape(QCData(:,1),npz,npy,npx),idx_order)*0.529;
		
		varargout = {X,Y,Z};
	end
end