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
options1 = struct('format','pdf','outputDir',[pwd '/HW5_pdfs']);

%% Publish Problem #1
publish('HW5P1.m',options1);
close all;
%% Publish Problem #2
publish('HW4P2.m',options1);
close all;
%% Publish the Problem #3a
publish('HW4P3a.m',options1);
close all;
%% Publish the Problem #2
publish('HW4P2.m',options1);
close all