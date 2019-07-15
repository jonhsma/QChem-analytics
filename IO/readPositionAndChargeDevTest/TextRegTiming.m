% This script test the timing of text recognition functions
%% Try the new manual charge reader
addpath('..\');
testString = {[' ',9, '1 Si         776521.1358       '];...
    '1 Si         776521.1358       ';...
    ' 1 Si         776521.1358       ';...
    [' 1 Sic ' 9 9 ' 776521.1358']};

testHandles={@(x)sscanf(x,'%d %3s %f %f %f'), @(x)textscan(x,'%d %3s %f'),...
    @getElementAndCharge,@getElementAndCharge2};

nTest = 100000;

for ii = 1:numel(testHandles)
    fCurr = testHandles{ii};
    tic
    for jj = 1: numel(testString)
        for kk = 1:nTest
            [aE,aC1] = fCurr(testString{jj});
        end
        switch ii
            case 1
                aC = aE(3+length(aE)-aC1);
            case 2
                aC = aE{3};
            otherwise
                aC=aC1;
        end
        if aC~=776521.1358
            disp(['Warning, the charge is read to be '   num2str(aC)])
        else
            disp(['Charge correctly retrived for string ' testString{jj}]);
        end
    end

    toc
    disp(fCurr)
end