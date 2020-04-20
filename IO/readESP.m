% This function reads in the esp output of qchem. It doesn't compress it.
% It retains its original Nx4 structure. 
function y = readESP(filePath)
    esp_string = fileread(filePath);
    lb = find(esp_string==10,3);
    esp_matrix=str2num(esp_string(lb(end):end));
    
    y = esp_matrix;
end