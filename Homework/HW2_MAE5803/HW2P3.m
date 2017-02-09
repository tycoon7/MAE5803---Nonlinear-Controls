%% MAE 5803 - Homework #2 Problem #3
% Tim Coon: 9, February 2017

%%
clear; close all; clc;

%% Set default figure properties
set(0,'defaultlinelinewidth',2.5)
set(0,'defaultaxeslinewidth',2.5)
set(0,'defaultpatchlinewidth',2.5)
set(0,'defaulttextfontsize',14)
set(0,'defaultaxesfontsize',14)
set(0,'defaultTextInterpreter','latex')

tspan = [0 2];
[t,V] = ode45(@HW2P3_eqn,tspan,1,[]);

figure
plot(t,V)
xlabel('t')
ylabel('v')
hold off