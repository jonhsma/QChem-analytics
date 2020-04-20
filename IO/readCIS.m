% This funtion reads in the output of a q chem job (The input has to
% contain exactly one job) and extract the excited state information.

function results = readCIS(jobstring)
    %Identify the marker where the CIS session starts
    marker_beginning = regexp(jobstring,'TDDFT/TDA Excitation Energies','ONCE');
    
    if isempty(marker_beginning)
        results = -1;
        return;
    else
        marker_end = regexp(jobstring,'SETman timing summary','ONCE');
    end
    
    % Crop out the array and locate the line breaks
    cisString = jobstring(marker_beginning:marker_end);
    xMarkers = regexp(cisString,'Excited state');
    xMarkers = [xMarkers numel(cisString)];
    
    for ii =(numel(xMarkers)-1):-1:1
        % Split the strings
        lines = splitlines(cisString(xMarkers(ii):xMarkers(ii+1)-1));
        % Get the excited state number and the energy
        results(ii).xNumber     =   str2double(lines{1}(14:17));
        results(ii).xEnergy     =   str2double(lines{1}(44:end));
        %fprintf("State %6d\t Energy: %10.5f \n",xNumber,xEnergy)
        results(ii).xMoments = [str2double(lines{4}(18:24));...
            str2double(lines{4}(29:35));...
            str2double(lines{4}(40:46))];
        results(ii).strength = str2double(lines{5}(17:end));
        % Get the spin 
        if lines{3}(5)=="M"
            switch lines{3}(19)
                case "S" 
                    results(ii).S2 = 0;
                case "D" 
                    results(ii).S2 = 0.75;
                case "T" 
                    results(ii).S2 = 2;
                case "Q"
                    results(ii).S2 = 15/4;
            end
        else
            % In progress
            results(ii).S2 = -1;
        end
    end    
end