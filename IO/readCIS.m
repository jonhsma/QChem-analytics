% This funtion reads in the output of a q chem job (The input has to
% contain exactly one job) and extract the excited state information.

function results = readCIS(jobstring)
    %Identify the marker where the CIS session starts
    marker_beginning = regexp(jobstring,'Excitation Energies','ONCE');
	
	% The type of TDDFT
	%	0	TDA/TDDFT
	%	1	SA-SF-RPA
	type = 0;
	
    
    if isempty(marker_beginning)
        results = -1;
        return;
    else
%       marker_end = regexp(jobstring,...'SETman timing summary','ONCE');
		marker_end = regexp(jobstring(marker_beginning:end),...
			'time','ONCE')+...
			marker_beginning-1;
		if ~isempty(regexp(jobstring,'SA-SF-RPA','ONCE'))
			type =1;
		elseif ~isempty(regexp(jobstring,'SF-DFT','ONCE'))
			type = 2;
		end
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
		%results(ii).tEnergy     =   str2double(lines{2}(28:59));
		line_data = sscanf(strip(lines{2}),"Total energy for state %d: %f %s");
		results(ii).tEnergy = line_data(2);
		
		%The transition moments
		if type == 1 || type ==2
			results(ii).xMoments = [NaN NaN NaN];
			results(ii).strength = NaN;	
		else
			results(ii).xMoments = [str2double(lines{4}(18:24));...
				str2double(lines{4}(29:35));...
				str2double(lines{4}(40:46))];
			results(ii).strength = str2double(lines{5}(17:end));
		end
		
		
		% Get the spin 
		if lines{3}(5)=="M" || type==1
			% Restrict calculations
			if type == 1
				key = lines{3}(5);
			else
				key = lines{3}(19);
			end
            switch key
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
            % Unrestricted calculations
            results(ii).S2 = str2double(lines{3}(18:24));
		end
    end    
end