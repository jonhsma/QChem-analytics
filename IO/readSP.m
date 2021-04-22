% This function gathers information from single point calculations outputs
function data = readSP(jobString)
    lineBreaks = regexp(jobString,'[\n]');
	
	%Set the default outputs in case the computation crashes
	data.virAlpha   =   NaN;
    data.occAlpha   =   NaN;
    data.occBeta    =   NaN;
    data.virBeta    =   NaN;
	data.energy		=	NaN;
	
    %% Get the positions
    positionStart   = strfind(jobString,'Standard Nuclear Orientation (Angstroms)');
    if ~isempty(positionStart)
        %positionEnd     = strfind(jobString,'Molecular Point Group');
		positionEnd     = strfind(jobString(positionStart:end),...
			'----------------------------------------------------------------');
		positionEnd	= positionEnd(2)+positionStart;

        table = jobString(positionStart:positionEnd-1);

        lnBrks = regexp(table, '[\n]');
        nBrks = size(lnBrks,2);

        element     = zeros([nBrks-4 5]);
        coordinates = zeros([nBrks-4 3]);

        for ii = 3:nBrks-1
            [items,nElements] = sscanf(table(lnBrks(ii):lnBrks(ii+1)),'%d %3s %f %f %f');    
            elementLength = size(items,1)-nElements+1;
            element(ii-2,1:elementLength) = items(2:end - 3);    
            coordinates(ii-2,:)= items(end - 2:end);
        end

        data.element   =   element;
        data.coordinates =   coordinates;
    end 
    %% Get the basis
    b_Start = sort([regexp(jobString,'BASIS ','ignorecase'),...
		regexp(jobString,'BASIS[\t]','ignorecase')]);
    line_temp = jobString(b_Start(1):min(lineBreaks(lineBreaks>b_Start(1)))-1);
    obj_temp = textscan(erase(line_temp,'='),"%s %s");
    data.basis = obj_temp{2}{1};
    
    %% Get the method
    m_Start = sort([regexp(jobString,'METHOD ','ignorecase'),...
		regexp(jobString,'METHOD[\t]','ignorecase')]);
    line_temp = jobString(m_Start(1):min(lineBreaks(lineBreaks>m_Start(1)))-1);
    obj_temp = textscan(erase(line_temp,'='),"%s %s");
    data.method = obj_temp{2}{1};
    
    %% Get the final energy
    % See if MP2 calculations exist
    e_Start = regexp(jobString,'        MP2         total energy');    
    if ~isempty(e_Start)
        % If MP2 energy exists
        compString = "        MP2         total energy %s %f au";
    else
        e_Start = regexp(jobString,'Total energy in the final basis set');
        if isempty(e_Start)
            % The calculation didn't end well
            return;
        end
        compString = "Total energy in the final basis set %s %f";
    end
    line_temp = jobString(e_Start:min(lineBreaks(lineBreaks>e_Start))-1);
    obj_temp = textscan(line_temp,compString);
    data.energy = obj_temp{2};
    
    %% Get the  alpha orbital energies (only works for unrestricted calculations)
    occupiedOrbitals_start = regexp(jobString,'Alpha MOs');
    
    if isempty(occupiedOrbitals_start)
        % There is no orbital to read
        data.virAlpha   =   NaN;
        data.occAlpha   =   NaN;
        data.occBeta    =   NaN;
        data.virBeta    =   NaN;
        return
    end
    
    temp = regexp(jobString,'-- Virtual --');
    occupiedOrbitals_end = min(temp(temp>occupiedOrbitals_start))-1;
    
    % Now I have the range, find all the relavant line breaks
    lb_occOrb = lineBreaks(lineBreaks>occupiedOrbitals_start&lineBreaks<occupiedOrbitals_end);
    lb_occOrb = lb_occOrb(2:end);
    occOrbLines = splitlines(jobString(lb_occOrb(1)+1:lb_occOrb(end)));
    
    occOrb_energyString = [' '];
    for ii = 1 : numel(occOrbLines)
        if sum(occOrbLines{ii}>=65) == 0
            occOrb_energyString = [occOrb_energyString ' ' occOrbLines{ii}];
        end
    end
    % Remove the artifacts from not having enough decimal places (the
    % ******* in qchem output%
    occOrb_energyString = strrep(occOrb_energyString,'*******','-999 ');
    % Convert the orbital energies to numbers    
    data.occAlpha = str2num(occOrb_energyString);
    
    % Then the virtural orbitals
    virOrb_start    =   min(lineBreaks(lineBreaks>temp(1)));
    %virOrb_start    =   virOrb_start(min(end,3));
    temp = regexp(jobString(virOrb_start:end),'--------------------------------')+ virOrb_start;
	% In case the separator doesn't exist
	temp2 = regexp(jobString(virOrb_start:end),"Beta")+ virOrb_start;
	marker = min([temp temp2]);
	
	
    virOrb_end      =   max(lineBreaks(lineBreaks<marker));
    
    virOrbLines = splitlines(jobString(virOrb_start+1:virOrb_end-1));
    
    virOrb_energyString = [' '];
    for ii = 1 : numel(virOrbLines)
        if sum(virOrbLines{ii}>=65) == 0
            virOrb_energyString = [virOrb_energyString ' ' virOrbLines{ii}];
        end
    end
    data.virAlpha = str2num(virOrb_energyString);
    
    %% Get the beta orbital energies (only works for unrestricted calculations)
    occupiedOrbitals_start = regexp(jobString,'Beta MOs');
    if ~isempty(occupiedOrbitals_start)
        temp = regexp(jobString,'-- Virtual --');
        occupiedOrbitals_end = min(temp(temp>occupiedOrbitals_start))-1;

        % Now I have the range, find all the relavant line breaks
        lb_occOrb = lineBreaks(lineBreaks>occupiedOrbitals_start&lineBreaks<occupiedOrbitals_end);
        lb_occOrb = lb_occOrb(2:end);
        occOrbLines = splitlines(jobString(lb_occOrb(1)+1:lb_occOrb(end)));

        occOrb_energyString = [];
        for ii = 1 : numel(occOrbLines)
            if sum(occOrbLines{ii}>=65) == 0
                occOrb_energyString = [occOrb_energyString ' ' occOrbLines{ii}];
            end
        end    
        data.occBeta = str2num(occOrb_energyString);

        % Then the virtural orbitals
        virOrb_start    =   min(lineBreaks(lineBreaks>occupiedOrbitals_end));
        %virOrb_start    =   virOrb_start(min(end,3));
        temp = regexp(jobString,'---------');
        virOrb_end      =   min(temp(temp>virOrb_start));

        virOrbLines = splitlines(jobString(virOrb_start+1:virOrb_end-1));

        virOrb_energyString = [];
        for ii = 1 : numel(virOrbLines)
            if sum(virOrbLines{ii}>=65) == 0
                virOrb_energyString = [virOrb_energyString ' ' virOrbLines{ii}];
            end
        end
        data.virBeta = str2num(virOrb_energyString);
    else 
        data.virBeta = -1;
        data.occBeta = -1;
	end
	
	%% Charges
	positionStart   = strfind(jobString,'Ground-State Mulliken Net Atomic Charges');
	if ~isempty(positionStart)
		positionEnd     = strfind(jobString,'Sum of atomic charges');

		table = jobString(positionStart:positionEnd-1);

		lnBrks = regexp(table, '[\n]');
		nBrks = size(lnBrks,2);

		element_2   = zeros([nBrks-5 5]);
		charge      = zeros([nBrks-5 1]);

		for ii = 4:nBrks-2
			[items,nElements] = sscanf(table(lnBrks(ii):lnBrks(ii+1)),'%d %3s %f %f');    
			elementLength = length(items)-nElements+1;
			element_2(ii-3,1:elementLength) = items(2:2+elementLength - 1);    
			charge(ii-3)= items(2+elementLength);
		end

		% check if the position list and charge list give the same elemets
		if sum(sum(element_2 - element))~=0
			disp(['Warning: inconsistency in atomic species between charge and position lists.'])
		end
		
	else
		charge = NaN;
	end
	data.charge = charge;
end

