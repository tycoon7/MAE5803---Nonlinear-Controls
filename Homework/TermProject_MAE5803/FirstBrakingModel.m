% Braking Model
clear; close all; clc;
% Given?
g = 9.81;               % (m/s^2) gravitational constant
% m = 100;                % (kg) vehicle mass
% R = 0.25;               % (m) wheel radius
% J = m*R^2/2;            % (kg-m^2) wheel rotational inertia
% nu = m*R^2/J;           % (-) inertia ratio
nu = 15;

% Best guess for c. These are unknown, but bounded for dynamics simulation
c = [1.18 10 0.5];      % (-) friction coefficient parameters

% Integrate
% tspan = [0 1];
% X0 = [0; 0];
% [t,X] = ode45(@EOM_qCarNL_Analysis,tspan,X0,[],g,c,nu);
% u = X(:,1);
% s = X(:,2);

tspan = [0 5];
s0 = 0;                     % no slip at the start
u0 = 20;                    % initial speed
wR = (1-s0)*u0;             % initial wR
X0 = [u0; wR];
[t,X] = ode45(@EOM_qCarNL_Dynamics,tspan,X0,[],g,c,nu);
u = X(:,1);
wR = X(:,2);
for i = 1:length(t)
    [~,s(i)] = EOM_qCarNL_Dynamics(t(i),X(i,:),g,c,nu);
end

figure(1)
subplot(211)
plot(t,u)
title('vehicle speed')
xlabel('time')
subplot(212)
plot(u,wR)