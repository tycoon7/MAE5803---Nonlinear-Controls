function [dx,wR,tau] = EOM_qCarNL_Adaptive(t,x,g,c,nu,s_d,mu_d,v_0)
dx = zeros(size(x));
v = x(1);
s = x(2);
q_d = [v; s];
a_hat = x(3);

% friction coefficient model
mu = c(1)*(1-exp(-c(2)*s)) - c(3)*s;
% mu is scaled by a_hat, but maximum friction stays at s_d

% optimal brake torque
% Y_bd = mu_d*(1+nu-s_d);

% unknown parameter
a = 0.9;

% user-defined controller parameters
Lambda = diag([0.0, 0.2]);
P = 1;
Kd = 100*eye(2);

% adaptive controller
qd_d = [-a_hat*mu_d*g*t+v_0; s_d];
qd_dd = [-a_hat*mu_d*g; 0];
q_err = [0; 0];
q_err_d = q_d - qd_d;
qr_d = qd_d - Lambda*q_err;
qr_dd = qd_dd - Lambda*q_err_d;

H = (v/g)*eye(2);
C = [a*mu 0; a*mu*(nu-1) -a*mu];
Y = [mu*qr_d(1); mu*(nu+1)*qr_d(1)-mu*qr_d(2)];

xi = q_err_d + Lambda*q_err;
tau = H*qr_dd - Y*a_hat - Kd*xi;
% tau(1) = 0;
wR = (1-s)*v;

q_dd = inv(H)*(tau - C*q_d);
a_hat_d = -P*transpose(Y)*xi;

dx(1:2) = q_dd;
dx(3) = a_hat_d;
