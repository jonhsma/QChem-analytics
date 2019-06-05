% It returns the normal vector of the plane formed by the list of atoms
% specified
function [normVec,relativeError,cntr]=fitNormal(positions)
    
    cntr = mean(positions,1);
    X = positions - cntr;
    
    XXT     =   X'*X;
    [V,D]   =   eig(XXT);
    
    normVec = V(:,1);
    % This is the variance along the normal aixs devided by the total
    % variance
    relativeError=D(1,1)/sum(diag(D));
end
    