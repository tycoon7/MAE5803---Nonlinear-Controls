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
% publish('HW5P1.m',options1);
p = [1 2];
lambda = [1 2];
k = [1 2];
for i1 = 1:length(p)
    for i2 = 1:length(lambda)
        for i3 = 1:length(k)
            HW5P1(p(i1),lambda(i2),k(i3))
            figureName = ['HW1P1_p' num2str(p(i1)) '_lam' num2str(lambda(i2)) '_k' num2str(k(i3))];
            print(['HW5P1_pdfs\' figureName],'-dpdf')
        end
    end
end
close all;
%% Publish Problem #2
% publish('HW4P2.m',options1);
D = [0.1 0.5 1.0];
for j1 = 1:length(D)
    HW5P2(D(j1))
    figureName = strrep(['HW5P2_D' num2str(D(j1))],'.','o');
    print(['HW5P2_pdfs\' figureName],'-dpdf')
end
close all;
%% Publish the Problem #3a
% publish('HW4P3a.m',options1);
HW5P3a()
figureName = 'HW5P3a';
print(['HW5P3a_pdfs\' figureName],'-dpdf')
close all;
%% Publish the Problem #3b
% publish('HW4P3b.m',options1);
HW5P3b()
close all;