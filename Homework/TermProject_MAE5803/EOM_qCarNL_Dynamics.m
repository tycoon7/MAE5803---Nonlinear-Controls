function [dx,s,H] = EOM_qCarNL_Dynamics(t,x,g,c,nu)
dx = zeros(size(x));
u = x(1);
wR = x(2);

s = (u-wR)/u;      % wheel slip for braking conditions (u>=omega*R)

% friction coefficient model
mu = c(1)*(1-exp(-c(2)*s)) - c(3)*s;

% braking torque (simple proportional control)
% kb = 0.0125*u; % braking gain on the momentum of the car
% T_b = kb*u;
T_b = 12;

% H what's it called?
H = nu*mu - T_b;

u_dot = -mu*g;
wR_dot = g*H; % omega_dot should be zero if no torque... g/R = nu*mu? Yes. s=0 (no slip) so mu=0

dx(1) = u_dot;
dx(2) = wR_dot;