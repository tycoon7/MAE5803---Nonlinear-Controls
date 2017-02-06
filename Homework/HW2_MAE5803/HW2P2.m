%% MAE 5803 - Homework #2 Problem #2
% Tim Coon: 9, February 2017
%%
clear; close all; clc;

%% Equilibrium Points and Stability
% Fo the following systems, find the equilibrium points and determine their
% stability. Indicate if the stability is asymptotic and if it is global.
%
% $$ \dot{x} = -x^3 + \sin^{4}(x) $$
%
% $$ \dot{x} = (5-x)^5 $$
%
% $$ \ddot{x} + \dot{x}^5 + x^7 = x^2\sin^{8}(x)\cos^2(3x) $$
%
% $$ \ddot{x} + (x-1)^4\dot{x}^7 + x^5 = x^3\sin^{3}(x) $$
%
% $$ \ddot{x} + (x-1)^2\dot{x}^7 + x = \sin\frac{\pi x}{2} $$
%

%% Eqn #1:
% First-order state equation
%
% $$ \dot{x} = -x^3 + \sin^{4}(x) $$
%
% This system has an equilibrium point at $x=0$. It is an asymptotically
% stable node. $\dot{x}$ is positive whenever $x$ is negative and vice
% versa.
figure()
ezplot('-x^3 + sin(x)^4')
xlabel('x'); ylabel('\dot{x}');

%% Eqn #2:
% First-order state equation
%
% $$ \dot{x} = (5-x)^5 $$
%
% This system has an equilibrium point at $x=5$. It is an asymptotically
% stable node. $\dot{x}$ is positive whenever $x$ is negative and vice
% versa.
figure()
ezplot('(5-x)^5')
xlabel('x'); ylabel('\dot{x}');

%% Eqn #3:
% First-order state equation
%
% $$ \dot{x_1} = x_2 $$
%
% $$ \dot{x_2} = x_1^2\sin^{8}(x_1)\cos^2(3x_1) - x_1^7 - x_2 $$
%
HW1P2_plotPhasePortrait(3,[0 2],[-2 2],[-2 2],'System #3')

%% Eqn #4:
% First-order state equation
%
% $$ \dot{x_1} = x_2 $$
%
% $$ \dot{x_2} = x_1^3\sin^3(x_1) - (x_1-1)^4x_2^7 - x_1^5 $$

%% Eqn #5:
% First-order state equation
%
% $$ \dot{x_1} = x_2 $$
%
% $$ \dot{x_2} = \sin\frac{\pi x_1}{2} - (x_1-1)^2x_2^7 - x_1 $$

%% Plots
% The 2-dimensional function is plotted for the specified region by simply
% limiting the region in the tangential direction and viewing normal to the
% x1-x2 plane.
%
% for i = 1: length(f)
%     figure(i);
%     fsurf(f(i,1))
%     xlim([-2 2]); ylim([-2 2]); zlim([0 1]);
%     view(2)
%     title(f{i,2},'Interpreter','tex')
% end
