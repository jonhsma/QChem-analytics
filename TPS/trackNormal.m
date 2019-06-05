function [normVecList,errorList,cntrList]=trackNormal(idxList,positions)
    posActive = positions(idxList,:,:);
    nSteps = size(posActive,3);
    
    normVecList =   zeros([nSteps 3]);
    cntrList    =   normVecList;
    errorList   =   zeros([nSteps 1]);
    
    for ii = 1:nSteps
        [normVec, error, cntr] = fitNormal(posActive(:,:,ii));
        normVecList(ii,:)   =   normVec;
        errorList(ii)       =   error;
        cntrList(ii,:)      =   cntr;
    end
end