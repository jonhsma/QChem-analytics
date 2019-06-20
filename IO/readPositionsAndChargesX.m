function [names,positions,charges] = readPositionsAndChargesX(filePath)
    
    content = fileread(filePath);

    %% Locate the dividers
    labelLocations = strfind(content, 'TIME STEP');
    nSteps = size(labelLocations,2);
    labelLocations = [labelLocations size(content,2)];
    nExcitedStates = 0;

    %% Go through the chunks
    for chunk = 1: nSteps        

        chunkText = content(labelLocations(chunk):labelLocations(chunk+1)-1);
        %display(chunkText)
        
        %% Positions

        positionStart   = strfind(chunkText,'Standard Nuclear Orientation (Angstroms)');
        if isempty(positionStart)
            break
        end
        positionEnd     = strfind(chunkText,'Nuclear Repulsion Energy');

        table = chunkText(positionStart:positionEnd-1);

        lnBrks = regexp(table, '[\n]');
        nBrks = size(lnBrks,2);

        element     = zeros([nBrks-4 5]);
        coordinates = zeros([nBrks-4 3]);

        for ii = 3:nBrks-2
            [items,nElements] = sscanf(table(lnBrks(ii):lnBrks(ii+1)),'%d %3s %f %f %f');    
            elementLength = size(items,1)-nElements+1;
            element(ii-2,1:elementLength) = items(2:end - 3);    
            coordinates(ii-2,:)= items(end - 2:end);
        end
        if chunk ==1
            % initialize the final array
            elementArray     = zeros([nBrks-4 5 nSteps]);
            coordinatesArray = zeros([nBrks-4 3 nSteps]);
        end
        elementArray(:,:,chunk)     =   element;
        coordinatesArray(:,:,chunk) =   coordinates;
        
        %% Charges
        %positionStart   = strfind(chunkText,'Ground-State Mulliken Net Atomic Charges');
        positionsStart   = strfind(chunkText,'Mulliken Net Atomic Charges');

        if isempty(positionsStart)
            if chunk ==1
                chargeArray = NaN;
            end
            continue
        end
        positionsEnd     = strfind(chunkText,'Sum of atomic charges');
        
        if chunk == 1
            % Literally the number of excited state
            % The -1 is there to avoid ambiguity
            nExcitedStates = min(numel(positionsStart), numel(positionsEnd))-1;
            if numel(positionsStart)~=numel(positionsEnd)
                disp('warning')
            end
        end
        
        % the in-loop charge array
        charge      = zeros([nBrks-5 nExcitedStates 1]);
            
        for jj = 1:nExcitedStates+1 % +1 to include the ground state
            table = chunkText(positionsStart(jj):positionsEnd(jj));

            lnBrks = regexp(table, '[\n]');
            nBrks = size(lnBrks,2);

            element_2   = zeros([nBrks-5 5]);

            for ii = 4:nBrks-2
                [items,nElements] = sscanf(table(lnBrks(ii):lnBrks(ii+1)),'%d %3s %f');    
                elementLength = length(items)-nElements+1;
                element_2(ii-3,1:elementLength) = items(2:end - 1);    
                charge(ii-3,jj)= items(end);
            end

            % check if the position list and charge list give the same elemets
            if sum(sum(element_2 - element))~=0
                disp(['Warning: inconsistency in atomic species between charge and position lists.'...
                      'Time Step : ' num2str(chunk)])
            end
        end
        
        if chunk ==1
            % initialize the final array
            chargeArray     = zeros(nBrks-5,nExcitedStates+1,nSteps);
        end
        chargeArray(:,:,chunk) =   charge;
    end
    
    if isempty(positionStart)
        elementArray        =   elementArray(:,:,1:chunk-1); 
        coordinatesArray    =   coordinatesArray(:,:,1:chunk-1);
        if ~isnan(chargeArray)
            chargeArray         =   chargeArray(:,:,1:chunk-1);
        end
    end
    if(sum(sum(std(double(elementArray(:,:,:)),1,3)))~= 0)
       disp('Warning: Atomic element change during reaction detected. Check integrity of the input file') 
    else
        elementArray = mean(elementArray,3);
    end
    
    names       =   char(elementArray);
    positions   =   coordinatesArray;
    charges     =   chargeArray;
end