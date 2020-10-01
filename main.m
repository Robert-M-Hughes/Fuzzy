%% the fuzzinator
clear all
close all
clc
profile('off'); profile('on');

%Let the user pick the number of centroids
prompt = 'How many centroids? ';
Q = input(prompt);  % number of centroids to find
%get the data from the provided file
D = importdata('clusterdata.mat');
% run the fuzzinator
C = fuzzy(D, Q, [2 1000 1e-30]);
figure
plot3(D(:,1),D(:,2),D(:,3),'.b','linewidt',2);
set(gca,'nextplot','add');
plot3(C(:,1),C(:,2),C(:,3),'xr','linewidt',3);
h = legend('Dataset','Centroids from the FUZZINATOR');
set(h,'fontsize',8,'fontweight','bold');
title('Fuzziest of Logic Analyzer')
