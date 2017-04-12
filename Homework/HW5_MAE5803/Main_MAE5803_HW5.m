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
options1 = struct('format','pdf','outputDir',[pwd '/HW5P1_pdfs'],'evalCode',false);
options2 = struct('format','pdf','outputDir',[pwd '/HW5P2_pdfs'],'evalCode',false);
options3a = struct('format','pdf','outputDir',[pwd '/HW5P3a_pdfs'],'evalCode',false);
options3b = struct('format','pdf','outputDir',[pwd '/HW5P3b_pdfs'],'evalCode',false);

%% Publish Problem #1
publish('HW5P1.m',options1);
plk = [1 1 1; 1 1 2; 1 2 1; 2 1 1];
for i1 = 1:4
    HW5P1(plk(i1,1),plk(i1,2),plk(i1,3))
    figureName = ['HW5P1_p' num2str(plk(i1,1)) '_lam' num2str(plk(i1,2)) '_k' num2str(plk(i1,3))];
    print(['HW5P1_pdfs\' figureName],'-dpdf','-fillpage')
end
close all;
%% Publish Problem #2
publish('HW5P2.m',options2);
D = [0.5 1.0 2.0];
for j1 = 1:length(D)
    HW5P2(D(j1))
    figureName = strrep(['HW5P2_D' num2str(D(j1))],'.','o');
    print(['HW5P2_pdfs\' figureName],'-dpdf','-fillpage')
end
close all;
%% Publish the Problem #3a
publish('HW5P3a.m',options3a);
HW5P3a()
figureName = 'HW5P3a PD Control';
print(['HW5P3a_pdfs\' figureName],'-dpdf','-fillpage')
close all;
%% Publish the Problem #3b
publish('HW5P3b.m',options3b);
HW5P3b()
close all;