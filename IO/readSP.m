% This function gathers information from single point calculations outputs
function data = readSP(jobString)
    lineBreaks = regexp(jobString,'[\n]');
    
    %% Get the basis
    b_Start = sort([regexp(jobString,'BASIS '),regexp(jobString,'BASIS[\t]')]);
    line_temp = jobString(b_Start:min(lineBreaks(lineBreaks>b_Start))-1);
    obj_temp = textscan(line_temp,"%s %s");
    data.basis = obj_temp{2}{1};
    
    %% Get the method
    m_Start = sort([regexp(jobString,'METHOD '),regexp(jobString,'METHOD[\t]')]);
    line_temp = jobString(m_Start:min(lineBreaks(lineBreaks>m_Start))-1);
    obj_temp = textscan(line_temp,"%s %s");
    data.method = obj_temp{2}{1};
    
    %% Get the final energy
    e_Start = regexp(jobString,'Total energy in the final basis set');
    if isempty(e_Start)
        % The calculation didn't end well
        return;
    end
    line_temp = jobString(e_Start:min(lineBreaks(lineBreaks>e_Start))-1);
    obj_temp = textscan(line_temp,"Total energy in the final basis set %s %f");
    data.energy = obj_temp{2};
    
    %% Get the  alpha orbital energies (only works for unrestricted calculations)
    occupiedOrbitals_start = regexp(jobString,'Alpha MOs');
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
    data.occAlpha = str2num(occOrb_energyString);
    
    % Then the virtural orbitals
    virOrb_start    =   min(lineBreaks(lineBreaks>occupiedOrbitals_end));
    %virOrb_start    =   virOrb_start(min(end,3));
    temp = lineBreaks(diff(lineBreaks)<=2);
    virOrb_end      =   min(temp(temp>virOrb_start));
    
    virOrbLines = splitlines(jobString(virOrb_start+1:virOrb_end-1));
    
    virOrb_energyString = [];
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
end

