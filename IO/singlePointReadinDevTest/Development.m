%% This is the development script for reading SP jobs
set(0,'DefaultFigureWindowStyle','Docked')
addpath('..\')
addpath('SampleData')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1/2/2020  Put the positions back into the code
%% The cropping Tool
fileString = fileread('SampleData\PBE0.def2-QZVPD.C10H8.out');
jobStrings = cropJob(fileString);

%% Gathering the info
jobString1 = jobStrings{1};
lineBreaks = regexp(jobString1,'[\n]');
b_Start = sort([regexp(jobString1,'BASIS '),regexp(jobString1,'BASIS[\t]')]);
basisLine = jobString1(b_Start:min(lineBreaks(lineBreaks>b_Start))-1);
%% Get the pattern, now try to build the reader
data_temp = readSP(jobString1);
%% Trial run
for ii = 1: numel(jobStrings)
    data(ii)=readSP(jobStrings{ii});
end

disp([data.energy])
disp(data(2).energy-data(1).energy)
disp(data(1).virAlpha(1))
disp(data(2).occAlpha(end))

%% Calculate the total interaction energy and single particle energy
% neutral state
fprintf(" Total interaction energy of the neutral state %f \n",sum([data(1).occAlpha,data(1).occBeta])-data(1).energy)
% anion
% neutral state
fprintf(" Total interaction energy of the anionic state %f \n",sum([data(2).occAlpha,data(2).occBeta])-data(2).energy)

% neutral state
fprintf(" Total single particle energy of the neutral state %f \n",-sum([data(1).occAlpha,data(1).occBeta])+2*data(1).energy)
% anion
% neutral state
fprintf(" Total single particle energy of the anionic state %f \n",-sum([data(2).occAlpha,data(2).occBeta])+2*data(2).energy)
