% This script is a development script for the function that reads the
% positions and charges of atoms. For it's nature. run it from this
% directory

%% Initialization 
set(0,'DefaultFigureWindowStyle','Docked')
addpath('..\');

%% Don't mess with the charges yet. Try to find a strategy to read the file
testFile = 'FSSH.X1.Iter05.out';
content = fileread(testFile);

%% Locate the first scan
labelLocations = strfind(content, 'TIME STEP');
labelLocations = [labelLocations size(content,2)];

%% pull a chunk out
chunk = 702;

chunkText = content(labelLocations(chunk):labelLocations(chunk+1)-1);
display(chunkText)

%% So now it's about analyzing the chunk

positionStart   = strfind(chunkText,'Standard Nuclear Orientation (Angstroms)');
positionEnd     = strfind(chunkText,'Nuclear Repulsion Energy');

table = chunkText(positionStart:positionEnd-1);

lnBrks = regexp(table, '[\n]');
nBrks = size(lnBrks,2);

element     = char([nBrks-4 5]);
coordinates = zeros([nBrks-4 3]);

for ii = 3:nBrks-2
    [items,nElements] = sscanf(table(lnBrks(ii):lnBrks(ii+1)),'%d %3s %f %f %f');    
    elementLength = nElements-4;
    element(ii-2,1:elementLength) = items(2:end - 3);    
    coordinates(ii-2,:)= items(end - 2:end);
end

%% Test the module
%The file with an Si in it
testFile = 'FSSH.X1.Iter05.StringTest.out';
[elementArray,coordinatesArray]=readPositionsAndCharges(testFile);

%test passed no problem

% Test using the two files
[elementArray05,coordinatesArray05]=readPositionsAndCharges('FSSH.X1.Iter05.out');
[elementArray12,coordinatesArray12]=readPositionsAndCharges('FSSH.X1.Iter12.out');

% Make sure that the elements align
if(sum(std(double(elementArray05(:,:,:)),1,3))~= 0)
    disp('warning')
end
if(sum(std(double(elementArray12(:,:,:)),1,3)) ~= 0)
    disp('warning')
end

%% Final test for positions
% Make sure these two gives no error
[elementArray05,coordinatesArray05]=readPositionsAndCharges('FSSH.X1.Iter05.out');
[elementArray12,coordinatesArray12]=readPositionsAndCharges('FSSH.X1.Iter12.out');

[elementArray05st,coordinatesArray05st]=readPositionsAndCharges('FSSH.X1.Iter05.StringTest.out');
if (length(size(elementArray05st))~=3)
    disp('Unable to detect in-reaction atomic element descrapency')
end

%% Charges
testFile = 'FSSH.X11.Iter06.out';
content = fileread(testFile);

%% Locate the first scan
labelLocations = strfind(content, 'TIME STEP');
labelLocations = [labelLocations size(content,2)];
%% pull a chunk out
chunk = 702;
chunkText = content(labelLocations(chunk):labelLocations(chunk+1)-1);
display(chunkText)

%% So now it's about analyzing the chunk

positionStart   = strfind(chunkText,'Ground-State Mulliken Net Atomic Charges');
positionEnd     = strfind(chunkText,'Sum of atomic charges');

table = chunkText(positionStart:positionEnd-1);

lnBrks = regexp(table, '[\n]');
nBrks = size(lnBrks,2);

element     = char([nBrks-5 5]);
charge      = zeros([nBrks-5 1]);

disp('There we go')
for ii = 4:nBrks-2
    [items,nElements] = sscanf(table(lnBrks(ii):lnBrks(ii+1)),'%d %3s %f');    
    elementLength = length(items)-2;
    element(ii-3,1:elementLength) = items(2:end - 1);    
    charge(ii-3)= items(end);
end

%% Test for charges
[elementArray05,coordinatesArray05,chargeArray05]=readPositionsAndCharges('FSSH.X1.Iter05.out');
[elementArray06,coordinatesArray06,chargeArray06]=readPositionsAndCharges('FSSH.X11.Iter06.out');
[elementArray06e,coordinatesArray06e,chargeArray06e]=readPositionsAndCharges('FSSH.X11.Iter06.error.out');

%% Try to see if using text scan speeds things up (7/5/2019)
%before
tic
[~,~,~]=readPositionsAndChargesX('FSSH.X1.Iter05.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.error.out');
toc
%7.39 seconds
% after replacing sscanf in the excited state charge loop with textscan
tic
[~,~,~]=readPositionsAndChargesX('FSSH.X1.Iter05.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.error.out');
toc
%8.300377
% after replacing sscanf everywhere
tic
[~,~,~]=readPositionsAndChargesX('FSSH.X1.Iter05.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.error.out');
toc
%10.335466
% restoring all scanf
tic
[~,~,~]=readPositionsAndChargesX('FSSH.X1.Iter05.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.out');
[~,~,~]=readPositionsAndChargesX('FSSH.X11.Iter06.error.out');
toc
% Holy shit, sscanf is faster....