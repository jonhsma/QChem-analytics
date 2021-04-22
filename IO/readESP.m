% This function reads in the esp output of qchem. It doesn't compress it.
% It retains its original Nx4 structure. 
function y = readESP(filePath)
    esp_string = fileread(filePath);
	lb0 = find(esp_string=='X',1);
    lb1 = find(esp_string(lb0:end)==10,1);
    esp_matrix=str2num(esp_string(lb0+lb1:end));
    
    y = esp_matrix;
end