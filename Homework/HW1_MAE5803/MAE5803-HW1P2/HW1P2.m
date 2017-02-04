%% MAE 5803 - Homework #1 Problem #2
% Tim Coon: 25, January 2017
%%
clear; close all; clc;

%% Consider the following second-order system
%
% $$ \dot{x}_1 = \mu - x^2_1 $$
%
% $$ \dot{x}_2 = -x_2 $$

%% a) Identify Singular points
% For $\mu = 1$, find the singular points of the system, then determine the stability of the singular points by analyzing the linearized equation about each singular point. Generate the phase portrait of the system using MATLAB(R) to confirm your analysis. Frame your plot so that the horizontal and vertical axes range from -2 to 2.
%
mu = 1;
tspan = [0 1];
figure();
hold on
for x1 = -2:.5:2
    for x2 = -2:.5:2
        X0 = [x1; x2];
        [t,X] = ode45(@P2stateEqn,tspan,X0,[],mu);
        h = plot(X(:,1),X(:,2));
        c = get(h,'color');
        plot(X0(1),X0(2),'+','color',c);
    end
end
axis([-2 2 -2 2])
xlabel('$x_1$')
ylabel('$x_2$')
title('Nonlinear system phase portrait, $\mu = 1$')
hold off

%% First Singular Point
% The first singular point is a stable node at (1,0). Use the
% Jacobian to linearize about this point. Both eigenvalues have negative
% real parts, supporting the ID as a stable focus.
%
% $$ A_1 = \left.\frac{\partial{\bar{f}}}{\partial{\bar{x}}}\right\vert_{\bar{x}=(1,0)} $$
%
% $$ \frac{\partial{f_1}}{\partial{x_1}} = -2x_1 \quad
%    \frac{\partial{f_1}}{\partial{x_2}} = 0     \quad
%    \frac{\partial{f_2}}{\partial{x_1}} = 0     \quad
%    \frac{\partial{f_2}}{\partial{x_2}} = -1    $$
%
% $$ A_1 = \pmatrix{-2&0\cr
%                    0&-1\cr}$$
eValue1 = eig([-2 0; 0 -1])


%% Second Singular Point
% The second singular point is a saddle point at (-1,0). Use the
% Jacobian to linearize about this point. Both eigenvalues have negative
% real parts, supporting the ID as a stable focus.
%
% $$ A_2 = \left.\frac{\partial{\bar{f}}}{\partial{\bar{x}}}\right\vert_{\bar{x}=(-1,0)} $$
%
% $$ A_2 = \pmatrix{2&0\cr
%                   0&-1\cr}$$
eValue2 = eig([2 0; 0 -1])

%% b) Let $\mu = 0$.
% Repeat part (a) for $\mu = 0$.
%
mu = 0;
tspan = [0 4];
figure();
hold on
for x1 = -2:.5:2
    for x2 = -2:1:2
        X0 = [x1; x2];
        [t,X] = ode45(@P2stateEqn,tspan,X0,[],mu);
        h = plot(X(:,1),X(:,2));
        c = get(h,'color');
        plot(X0(1),X0(2),'+','color',c);
    end
end
axis([-2 2 -2 2])
xlabel('$x_1$')
ylabel('$x_2$')
title('Nonlinear system phase portrait, $\mu = 0$')
hold off

%% Singular Point, $\mu = 0$
% The singular point is on the origin. Use the
% Jacobian to linearize about this point. One eigenvalue at the origin of
% the complex plane with no negative eigenvalues means the stability of the
% system cannot be determined by the eigenvalues alone. From the phase
% portrait, it is clear any state in the right-half plane tends toward the
% origin. This would indicate stability were it mirrored by the left-half
% plane. However, any state in the left-hand plane escapes along the
% negative $x_2$ axis, so the node is unstable.
%
% $$ A_2 = \left.\frac{\partial{\bar{f}}}{\partial{\bar{x}}}\right\vert_{\bar{x}=(0,0)} $$
%
% $$ A_2 = \pmatrix{0&0\cr
%                   0&-1\cr}$$
eValue1 = eig([0 0; 0 -1])

%% c) Let $\mu = -1$ 
% Repeat again part (a) for $\mu = -1$.
%
% The linearized systems look the same because $\mu$ only affects the
% forcing function
mu = -1;
tspan = [0 1];
figure();
hold on
for x1 = -2:.5:2
    for x2 = -2:.5:2
        X0 = [x1; x2];
        [t,X] = ode45(@P2stateEqn,tspan,X0,[],mu);
        h = plot(X(:,1),X(:,2));
        c = get(h,'color');
        plot(X0(1),X0(2),'+','color',c);
    end
end
axis([-2 2 -2 2])
xlabel('$x_1$')
ylabel('$x_2$')
title('Nonlinear system phase portrait, $\mu = -1$')
hold off

%% No Singular Points for $\mu = -1$
% There are no singular points within the range $-2 \leq x_1,x_2 \leq 2$.

%% d) Comments
% What phenomenon do you observe as the parameter, $\mu$, varies as in the above? Explain the reason for your answer.
%
% For $/mu < 0$, There are no singular points. This is an example of
% bifurcation. Bifurcation occurs when a small, smooth change made to the
% parameter value(s) of a system causes a sudden qualitative or topological
% change in its behavior. The infinitesimal change from positive to
% negative $\mu$ causes the drastic change to the system stability shown in
% the phase portraits.