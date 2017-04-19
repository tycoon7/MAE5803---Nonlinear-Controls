function [dx,s,H,Y_b] = EOM_qCarNL_Dynamics(t,x,g,c,nu,s_d)
dx = zeros(size(x));
u = x(1);
wR = x(2);

if u <= eps
   u_dot = 0;
   wR_dot = 0;
   s = 0;
   H = 0;
   Y_b = 0;
else

s = (u-wR)/u;      % wheel slip for braking conditions (u>=omega*R)
if isnan(s)
    disp('s=Nan')
end

% friction coefficient model
mu = c(1)*(1-exp(-c(2)*s)) - c(3)*s;

% braking torque (simple proportional control)
kb = 0.1*u;       % braking gain on the momentum of the car (This makes it nonlinear!)
Y_b = kb*wR;    % braking torque (dimensionless) proportional to wheel speed
ks = 5;
Y_b = Y_b - ks*sign(s-s_d); % add a compensator to drive to s = s_d
% Y_b = 5;
% Y_b = 12;
if Y_b < 0
    Y_b = 0;
end

% H what's it called?
H = nu*mu - Y_b;

u_dot = -mu*g;
wR_dot = g*H; % omega_dot should be zero if no torque... g/R = nu*mu? Yes. s=0 (no slip) so mu=0
end

dx(1) = u_dot;
dx(2) = wR_dot;