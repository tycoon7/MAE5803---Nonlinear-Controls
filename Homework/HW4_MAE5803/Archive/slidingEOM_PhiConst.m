%% Equation of Motion
function [dx, s, phi, u, Fd] = slidingEOM_PhiConst(t,x,m,a1_hat,a2_hat,d_hat,eta,lambda)
dx = zeros(size(x));
x1 = x(1);
x2 = x(2);
xd = 2*sin(t);
xd_dot = 2*cos(t);
xd_dd = -2*sin(t);

a1 = 5 + cos(t);
a2 = 1 + abs(sin(2*t));
d = cos(1.3*t);
f = (-1/m)*((a1 + a2*cos(x1)^2)*abs(x2)*x2 + d);
fd = (-1/m)*((a1 + a2*cos(xd)^2)*abs(xd_dot)*xd_dot + d);
b = 1/m;
f_hat = (-1/m)*((a1_hat + a2_hat*cos(x1)^2)*abs(x2)*x2 + d_hat);
fd_hat = (-1/m)*((a1_hat + a2_hat*cos(xd)^2)*abs(xd_dot)*xd_dot + d_hat);
F = abs(f-f_hat);
Fd = abs(fd-fd_hat);
k = F + eta;
kd = Fd + eta;
phi = 0.1;
% phi = kd/lambda;
phi_dot = 0;
% phi_dot = kd - lambda*phi;
s = x2 - xd_dot + lambda*(x1-xd);
u_hat = -f_hat + xd_dd - lambda*(x2-xd_dot);

if abs(s) >= phi
    u = u_hat - (k-phi_dot)*sign(s);
else
    u = u_hat - (k-phi_dot)*(s/phi);
end
    
dx(1) = x2;
dx(2) = f + b*u;

end