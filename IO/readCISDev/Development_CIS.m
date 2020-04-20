% This is the development script for the CIS reading module
% The aim of the module is to extract all information into a matlab data
% structure

% The composition of the transition is still left out there for the sake of
% time

%% Initializations
addpath(genpath('E:\Codes\Codes_LBNL\QChem-Analytics'));
set(0,'DefaultFigureWindowStyle','Docked')

%% Read the file. 
% At this point I just assume that the file string one feeds into the
% function contains only one job

testFile = '1_4_dibutylbenzene\trnss_av.out';
content = fileread(testFile);

temp = readCIS(content);
figure(7200)
plot(sum([temp.xMoments].^2),[temp.strength],'.')
figure(7200)
stem([temp.xEnergy],[temp.strength],'X')
