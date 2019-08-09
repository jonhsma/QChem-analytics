%% This function splits the a string in segments of claculations output
% It just splits the file and does nothing else
function segments = cropJob(fileText)
    %% Hardcoding the anchors
    ANCHOR_BEGINNING_OF_JOB='Q-Chem begins';
    %% Locate the anchors
    
    positions_break =   regexp(fileText, ANCHOR_BEGINNING_OF_JOB);
    
    nSegments = numel(positions_break);    
    segments = cell([nSegments 1]);
    
    positions_break = [positions_break length(fileText)+1];
    
    %% Slice up the file
    for ii = 1 : nSegments
        segments{ii} = fileText(positions_break(ii):positions_break(ii+1)-1);
    end    
end