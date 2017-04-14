function [dx] = EOM_qCarNL_Analysis(t,x,g,c,nu)
dx = zeros(size(x));
u = x(1);
s = x(2);

% friction coefficient model
mu = c(1)*(1-exp(c(2)*s)) - c(3)*s;

% h_b what's it called?
h_b = (s-1-nu)*mu + Y_b;

u_dot = -mu*g;
s_dot = (g/u)*h_b;

dx(1) = u_dot;
dx(2) = s_dot;