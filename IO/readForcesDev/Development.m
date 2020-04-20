%% This is the development script for reading SP jobs
set(0,'DefaultFigureWindowStyle','Docked')
addpath('..\')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1/2/2020  Put the positions back into the code
%% The cropping Tool
fileString = fileread('decyl_hydroxamic_acid_force.out');

%% Try to run it and see how to best read the table
readForce(fileString)