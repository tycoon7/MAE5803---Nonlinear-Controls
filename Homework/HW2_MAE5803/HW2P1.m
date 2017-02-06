%% MAE 5803 - Homework #2 Problem #1
% Tim Coon: 9, February 2017
%%
clear; close all; clc;

%% Norm Regions
% The norm used in the definitions of stability need not be the usual
% Euclidian norm. IF the state space is of finite dimension, $n$, stability
% and its type are independent of the choice of norm. However, a particular
% choice of norm may make analysis easier. For $n = 2$, draw the regions
% corresponding to the following norms.
%
% $$ ||x||^2 = x^2_1 + x^2_2 \leq 1 $$
%
% $$ ||x||^2 = x^2_1 + 5x^2_2 \leq 1 $$
%
% $$ ||x|| = |x_1| + |x_2| \leq 1 $$
%
% $$ ||x|| = sup(|x_1|,|x_2|) \leq 1 $$
%

%% Eqn #1: Euclidean Norm
% Plot $x^2_1 + x^2_2 = f_1$ for $f_1 \leq 1$.
f{1,1} = @(x1,x2) x1.^2 + x2.^2;
f{1,2} = '||x||^2 = x^2_1 + x^2_2 \leq 1';

%% Eqn #2:
% Plot $x^2_1 + 5x^2_2 = f_2$ for $f_2 \leq 1$.
f{2,1} = @(x1,x2) x1.^2 + 5*x2.^2;
f{2,2} = '||x||^2 = x^2_1 + 5x^2_2 \leq 1';

%% Eqn #3:
% Plot $x^2_1 + x^2_2 = f_3$ for $f_3 \leq 1$.
f{3,1} = @(x1,x2) abs(x1) + abs(x2);
f{3,2} = '||x|| = |x_1| + |x_2| \leq 1';

%% Eqn #4:
% Plot $x^2_1 + x^2_2 = f_4$ for $f_4 \leq 1$.
f{4,1} = @(x1,x2) max(abs(x1),abs(x2));
f{4,2} = '||x|| = sup(|x_1|,|x_2|) \leq 1';

%% Plots
% The 2-dimensional function is plotted for the specified region by simply
% limiting the region in the tangential direction and viewing normal to the
% x1-x2 plane.
%
for i = 1: length(f)
    figure(i);
    fsurf(f(i,1))
    xlim([-2 2]); ylim([-2 2]); zlim([0 1]);
    view(2)
    title(f{i,2},'Interpreter','tex')
end
