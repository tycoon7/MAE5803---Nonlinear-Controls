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

%% Set Options
options1 = struct('format','pdf','outputDir',[pwd '/HW4_pdfs']);

%% Publish Problem #1ab
publish('HW4P1_ab.m',options1)

%% Publish Problem #1cd
publish('HW4P1_cd.m',options1)

%% Publish the Problem #1ef
publish('HW4P1_ef.m',options1)

%% Publish the Problem #2
publish('HW4P2.m',options1)

close all