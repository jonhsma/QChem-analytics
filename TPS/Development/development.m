% This is a development script for a few functions
% To track charges of a list of atoms (should be straight forward)
% To fit a surface of the benzene rings and find the normal to the surface
% find the angle between a bond and a surface

%% Initializations
set(0,'DefaultFigureWindowStyle','Docked');
addpath('../../IO');
addpath('../Sampledata');
%% Load some data
% No charge info, ended up with benzene ion
[elementArray05,coordinatesArray05,chargeArray05]=readPositionsAndCharges('FSSH.X1.Iter05.out');
% No charge info, ended up with benzene radical
[elementArray12,coordinatesArray12,chargeArray12]=readPositionsAndCharges('FSSH.X1.Iter12.out');
% With charge info, ended up with benzene radical
[elementArray06,coordinatesArray06,chargeArray06]=readPositionsAndCharges('FSSH.X11.Iter06.out');

%% Track the charge in three benzene rings
fragment1 = {2:12,13:23,14:24,1:1};
plotCharge(fragment1,chargeArray06);

%% Get the normal of a plane 
