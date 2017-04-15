% Braking Model
clear; close all; clc;
% Given?
g = 9.81;               % (m/s^2) gravitational constant
m = 1000;                % (kg) vehicle mass
R = 0.5;               % (m) wheel radius
J = (9/10)*(m*R^2/2);            % (kg-m^2) wheel rotational inertia
% nu = m*R^2/J;           % (-) inertia ratio
nu = 15;

% Best guess for c. These are unknown, but bounded for dynamics simulation
c = [1.18 10 0.5];      % (-) friction coefficient parameters

figure(1)
hold on
tspan = [0 5];
s0 = 0;                      % no slip at the start
u0 = 20;                 % initial speed
% wR0 = (1-s0)*u0;             % initial wR
wR0 = 0:1:20;
for i1 = 1:length(wR0)
    X0{i1} = [u0; wR0(i1)];
    [t{i1},X{i1}] = ode45(@EOM_qCarNL_Dynamics,tspan,X0{i1},[],g,c,nu);
    u{i1} = X{i1}(:,1);
    wR{i1} = X{i1}(:,2);
    for i2 = 1:length(t{i1})
        [~,s{i1}(i2)] = EOM_qCarNL_Dynamics(t{i1}(i2),X{i1}(i2,:),g,c,nu);
    end
    plot(u{i1},wR{i1})
end
plot([0 20],[0 20],'k')
axis([0 20 0 20])
% axis equal
xlabel('u')
ylabel('wR')
title('Nonlinear system phase portrait')
ax = gca; ax.YAxisLocation= 'Right';
hold off

% %% Plot the field of the phase portrait
% [x1, x2] = meshgrid(-4:0.5:4, -4:0.5:4);
% x1dot = x2;
% x2dot = -0.6*x2 - 3.*x1 - x1.^2;
% figure()
% quiver(x1,x2,x1dot,x2dot,'AutoScaleFactor',5)
% axis([-5 5 -5 5])
% axis equal
% xlabel('$\Theta$')
% ylabel('$\dot{\Theta}$')
% title('Phase portrait with gradients')