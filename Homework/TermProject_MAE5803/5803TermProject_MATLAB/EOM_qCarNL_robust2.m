function [dx_d,wR] = EOM_qCarNL_robust2(t,x_d,g,c,nu,s_d,mu_d,v_0)
dx_d = zeros(size(x_d));
v = x_d(1);
s = x_d(2);

% friction coefficient model
mu = c(1)*(1-exp(-c(2)*s)) - c(3)*s;

% optimal brake torque
% Y_bd = mu_d*(1+nu-s_d);

% unknown parameter
th = 0.9;
th_hat = 1;
th_range = [0.8 1.2];

% user-defined controller parameters
lambda = 0.2;
eta = [0; 1];

% robust controller
xd_d = [-mu_d*g*t+v_0; s_d];
xt_d = x_d-xd_d;
A = eye(2)*lambda;
xd_dd = [-mu_d*g; 0];
f_hat = [-th_hat*mu*g; g*th_hat*mu*(s-1-nu)/v];
F = [0; abs(th_range(1)-th_hat)*g*mu*(s-1-nu)/v];
K = F + eta;
B = [0 0; 0 g/v];
u_hat = (-f_hat + xd_dd - A*xt_d);
xi = xt_d;
u = u_hat - K.*sign(s_d-s);
f = [-th*mu*g; nu*th*g];

wR = (1-s)*v;

dx_d = f + u;

% x_dd = f + U;
% dx_d = [x_dd; u; s];

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