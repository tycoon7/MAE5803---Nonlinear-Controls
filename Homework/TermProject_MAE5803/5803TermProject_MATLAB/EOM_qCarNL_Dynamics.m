function [dx,s,H,Y_b] = EOM_qCarNL_Dynamics(t,x,g,c,nu,s_d)
dx = zeros(size(x));
u = x(1);
wR = x(2);

if u <= eps || isnan(u)
   u_dot = 0;
   wR_dot = 0;
   s = 0;
   H = 0;
   Y_b = 0;
else
    
if wR < 0
wR = 0;
end


% wheel slip for braking conditions (u>=omega*R)
s = (u-wR)/u;

% friction coefficient model
mu = c(1)*(1-exp(-c(2)*s)) - c(3)*s;

% braking torque at arbitrarily chosen constant value
% Y_b = 5;
% Y_b = 12;

% braking torque constant value chosen to yield desired slip value found by
% setting h_b = 0 and solving for Y_b with s_d
% Y_b = mu_d*(1+nu-s_d);

% braking torque (simple proportional control)
% kp = 0;       % braking gain on the angular velocity of the wheel
% Y_b = kp*wR;    % braking torque (dimensionless) proportional to wheel speed

% switching control
ks = 20;
% Y_b = -ks*sign(s-s_d); % add a compensator to drive to s = s_d

% sliding control
sat = @(x,delta) min(max(x/delta,-1),1);
phi = .05;
Y_b = - ks*sat(s-s_d,phi);

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