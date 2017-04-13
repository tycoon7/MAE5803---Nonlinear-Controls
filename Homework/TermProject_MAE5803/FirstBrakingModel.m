% Braking Model

% Given?
g = 9.81;               % (m/s^2) gravitational constant
m = 1;                  % (kg) vehicle mass
R = 1;                  % (m) wheel radius
J = 2;                  % (kg-m^2) wheel rotational inertia
nu = m*R^2/J;           % (-) inertia ratio

% Best guess for c. These are unknown, but bounded for dynamics simulation
c = [1.18 10 0.5];      % (-) friction coefficient parameters

% Integrate
tspan = [0 1];
X0 = [0; 0];
[t,X] = ode45(@quarterCarBrakeEOM,tspan,X0,[],g,c,nu);
s = X(:,1);
u = X(:,2);

figure(1)
