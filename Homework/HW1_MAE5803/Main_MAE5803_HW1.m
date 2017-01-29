%% This script adds options and publishes each problem
clear; close all; clc;

%% suppress ode45 warnings
warning('off','MATLAB:ode45:IntegrationTolNotMet')

%% Set default figure properties
set(0,'defaultlinelinewidth',2.5)
set(0,'defaultaxeslinewidth',2.5)
set(0,'defaultpatchlinewidth',2.5)
set(0,'defaulttextfontsize',14)
set(0,'defaultaxesfontsize',14)
set(0,'defaultTextInterpreter','latex')

%% Set options for publishing
options = struct('format','pdf','outputDir',pwd);

%% Publish the Problem #1
cd('./MAE5803-HW1P1')
publish('HW1P1.m',options)
cd ..

%% Publish the Problem #2
options = struct('format','pdf','outputDir',pwd);
cd('./MAE5803-HW1P2')
publish('HW1P2.m',options)
cd ..

%% Publish the Problem #3
options = struct('format','pdf','outputDir',pwd);
cd('./MAE5803-HW1P3')
publish('HW1P3.m',options)
cd ..

%% Publish the Problem #4
options = struct('format','pdf','outputDir',pwd);
cd('./MAE5803-HW1P4')
publish('HW1P4.m',options)
cd ..

close all