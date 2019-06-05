% This is a development script for a few functions
% To track charges of a list of atoms (should be straight forward)
% To fit a surface of the benzene rings and find the normal to the surface
% find the angle between a bond and a surface

%% Initializations
set(0,'DefaultFigureWindowStyle','Docked');
addpath('../../IO');
addpath('../');
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

% make a hexagon
angle = (1/8:1/8:1)'*2*pi;
coord = [cos(angle), sin(angle), 0*angle];

fitNormal(coord)

%% track the normal of a benzene ring
ring1idx = [2 3 5 7 9 11];
[b1_n,b1_r,b1_c]=trackNormal(ring1idx,coordinatesArray05);
ring2idx = [13 14 16 18 20 22];
[b2_n,b2_r,b2_c]=trackNormal(ring2idx,coordinatesArray05);
ring3idx = [24 25 27 29 31 33];
[b3_n,b3_r,b3_c]=trackNormal(ring3idx,coordinatesArray05);

figure(7200)
hold off
plot3(b1_c(:,1),b1_c(:,2),b1_c(:,3))
hold on
plot3(b2_c(:,1),b2_c(:,2),b2_c(:,3))
plot3(b3_c(:,1),b3_c(:,2),b3_c(:,3))
legend('Ring 1','Ring 2','Ring 3')

% Get the carbon sulphr bond pointing
sB1_BV = squeeze(coordinatesArray05(2,:,:)-coordinatesArray05(1,:,:));
sB1_BV_n = sB1_BV./sum(sB1_BV.*sB1_BV,1);
sB1_BV_l = diag(sB1_BV'*sB1_BV);
sB2_BV = squeeze(coordinatesArray05(13,:,:)-coordinatesArray05(1,:,:));
sB2_BV_n = sB2_BV./sum(sB2_BV.*sB2_BV,1);
sB2_BV_l = diag(sB2_BV'*sB2_BV);
sB3_BV = squeeze(coordinatesArray05(24,:,:)-coordinatesArray05(1,:,:));
sB3_BV_n = sB3_BV./sum(sB3_BV.*sB3_BV,1);
sB3_BV_l = diag(sB3_BV'*sB3_BV);

% Get the anlges
proj_SB1 = diag(b1_n*sB1_BV_n);
proj_SB2 = diag(b2_n*sB2_BV_n);
proj_SB3 = diag(b3_n*sB3_BV_n);
figure(7201)
subplot(2,1,1)
plot(abs([proj_SB1, proj_SB2, proj_SB3]))
subplot(2,1,2)
plot(abs([sB1_BV_l, sB2_BV_l, sB3_BV_l]))

%% Temporarily package it
rings = {[2 3 5 7 9 11];[13 14 16 18 20 22];[24 25 27 29 31 33]};
TPS_dynamics(rings,1,coordinatesArray05,8100);
TPS_dynamics(rings,1,coordinatesArray06,8200);
TPS_dynamics(rings,1,coordinatesArray12,8300);

