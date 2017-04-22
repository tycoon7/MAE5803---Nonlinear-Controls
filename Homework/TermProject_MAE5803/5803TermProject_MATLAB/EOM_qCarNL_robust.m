function [dx,s,Y_b] = EOM_qCarNL_robust(t,x,g,c,nu,s_d,mu_d,u_0)
dx = zeros(size(x));
u = x(1);
wR = x(2);
% 
% if u <= eps
%    u_dot = 0;
%    wR_dot = 0;
%    s = 0;
%    H = 0;
%    Y_b = 0;
% else
    
if wR < 0
wR = 0;
end

% wheel slip for braking conditions (u>=omega*R)
s = (u-wR)/u;

% friction coefficient model
mu = c(1)*(1-exp(-c(2)*s)) - c(3)*s;

% optimal brake torque
Y_bd = mu_d*(1+nu-s_d);

% robust controller
th = 0.9;
th_hat = 1;
F = [0; 0.2];
f = [-th*mu*g; nu*th*g];
f_hat = [abs(th_hat-th)*mu*g+1; abs(th_hat-th)*mu*g+1];
u = -mu_d*g*t + u_0;
xd = [u; (1-s_d)*u];
xd_d = [-mu_d*g; g*(nu*mu_d-Y_bd)];
xi = x-xd;

dx = f - f_hat + xd_d - (F+1)*sign(s-s_d);

% if Y_b < 0
%     Y_b = 0;
% end

% H what's it called?
% H = nu*mu - Y_b;
% 
% u_dot = -mu*g;
% wR_dot = g*H; % omega_dot should be zero if no torque... g/R = nu*mu? Yes. s=0 (no slip) so mu=0
% 
% end
% 
% dx(1) = u_dot;
% dx(2) = wR_dot;