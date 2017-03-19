function [dx, s, u] = switchingEOM(t,x,m,a1_hat,a2_hat,d_hat,eta,lambda)
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
b = 1/m;
f_hat = (-1/m)*((a1_hat + a2_hat*cos(x1)^2)*abs(x2)*x2 + d_hat);
F = abs(f-f_hat);
k = F + eta;
s = x2 - xd_dot + lambda*(x1-xd);
u = -f_hat + xd_dd - lambda*(x2-xd_dot) - k*sign(s);

dx(1) = x2;
dx(2) = f + b*u;
end