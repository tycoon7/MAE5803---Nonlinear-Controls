function [dx, s, v] = P2switchingEOM(t,x,a1_hat,a2_hat,eta,lambda)
dx = zeros(size(x));
x1 = x(1);
x2 = x(2);
u = x(3);
xd = 2*sin(t);
xd_dot = 2*cos(t);
xd_dd = -2*sin(t);

a1 = sin(t);
a2 = 3*cos(t) + 2;
f = -a1*abs(x1)*x2^2 - a2*x1^3*cos(2*x1);
b = 1;
f_hat = -a1_hat*abs(x1)*x2^2 - a2_hat*x1^3*cos(2*x1);
F = abs(f-f_hat);
k = F + eta;
s = x2 - xd_dot + lambda*(x1-xd);
v = -f_hat + xd_dd - lambda*(x2-xd_dot) - k*sign(s);

dx(1) = x2;
dx(2) = f + b*v;
dx(3) = 0.2*(v - u);
end