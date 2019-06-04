% This function accpets a cell array of arrays indicating the positions of
% the element in the array
function [y,evolution] = plotCharge(clusters,charge)
    if ~iscell(clusters)
        y = -1;
        return
    end
    
    nClusters = length(clusters);
    evolution = zeros([length(clusters) size(charge,2)]);
    
    for ii = 1:nClusters
        subset = charge(clusters{ii},:);
        evolution(ii,:) = sum(subset,1);
    end
    
    plot(evolution');

end