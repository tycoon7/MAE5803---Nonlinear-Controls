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

%% Publish the Problem #1
options1 = struct('format','pdf','outputDir',[pwd '\HW1_pdfs']);
cd('./MAE5803-HW1P1')
publish('HW1P1.m',options1)
options2 = struct('format','pdf','outputDir','..\HW1_pdfs','evalCode',false);
publish('P1stateEqn.m',options2)
cd ..

%% Publish the Problem #2
options1 = struct('format','pdf','outputDir',[pwd '\HW1_pdfs']);
cd('./MAE5803-HW1P2')
publish('HW1P2.m',options1)
options2 = struct('format','pdf','outputDir','..\HW1_pdfs','evalCode',false);
publish('P2stateEqn.m',options2)
cd ..

%% Publish the Problem #3
options1 = struct('format','pdf','outputDir',[pwd '\HW1_pdfs']);
cd('./MAE5803-HW1P3')
publish('HW1P3.m',options1)
options2 = struct('format','pdf','outputDir','..\HW1_pdfs','evalCode',false);
publish('P3stateEqn.m',options2)
cd ..

%% Publish the Problem #4
options1 = struct('format','pdf','outputDir',[pwd '\HW1_pdfs']);
cd('./MAE5803-HW1P4')
publish('HW1P4.m',options1)
options2 = struct('format','pdf','outputDir','..\HW1_pdfs','evalCode',false);
publish('P4stateEqn.m',options2)
cd ..

close all