% This function gathers information from force calculations output files.
% Note that if you feed a SP file into it, it would pretty much work like
% read SP
function data = readForce(jobString)
    lineBreaks = regexp(jobString,'[\n]');
    %% Get the positions
    positionStart   = strfind(jobString,'Standard Nuclear Orientation (Angstroms)');
    if ~isempty(positionStart)
        positionEnd     = strfind(jobString,'Molecular Point Group');

        table = jobString(positionStart:positionEnd-1);

        lnBrks = regexp(table, '[\n]');
        nBrks = size(lnBrks,2);
        nAtoms = nBrks-4;

        element     = zeros([nAtoms 5]);
        coordinates = zeros([nAtoms 3]);
        
        

        for ii = 3:nBrks-2
            [items,nElements] = sscanf(table(lnBrks(ii):lnBrks(ii+1)),'%d %3s %f %f %f');    
            elementLength = size(items,1)-nElements+1;
            element(ii-2,1:elementLength) = items(2:end - 3);    
            coordinates(ii-2,:)= items(end - 2:end);
        end

        data.element   =   element;
        data.coordinates =   coordinates;
    end 
    %% Get the basis
    b_Start = sort([regexp(jobString,'BASIS '),regexp(jobString,'BASIS[\t]')]);
    line_temp = jobString(b_Start(1):min(lineBreaks(lineBreaks>b_Start(1)))-1);
    obj_temp = textscan(line_temp,"%s %s");
    data.basis = obj_temp{2}{1};
    
    %% Get the method
    m_Start = sort([regexp(jobString,'METHOD '),regexp(jobString,'METHOD[\t]')]);
    line_temp = jobString(m_Start(1):min(lineBreaks(lineBreaks>m_Start(1)))-1);
    obj_temp = textscan(line_temp,"%s %s");
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
    virOrb_start    =   min(lineBreaks(lineBreaks>occupiedOrbitals_end));
    %virOrb_start    =   virOrb_start(min(end,3));
    temp = lineBreaks(diff(lineBreaks)<=2);
    virOrb_end      =   min(temp(temp>virOrb_start));
    
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
    
    %% Get the forces
    positionStart = strfind(jobString,'Gradient of SCF Energy');
    if ~isempty(positionStart)
        positionEnd = strfind(jobString,'Max gradient component');
        
        forceString = jobString(positionStart:positionEnd);
        
        lnBrks = regexp(forceString, '[\n]');
        nBrks = size(lnBrks,2);
        nLines = (nBrks-1)/4;
        
        forceArray = zeros([3 nAtoms]);
        
        currentPos=1;
        for jj = 0:nLines - 1
            currChunk = str2double(forceString(lnBrks(jj*4+2)+1:lnBrks(jj*4+5)-2));
            nextPos = currentPos+size(currChunk,2)-1;
            forceArray(:,currentPos:nextPos-1) = currChunk(:,2:end);
            currentPos = nextPos;
        end
        
        disp(positionString);
        data.force = forceArray;
    end
end

