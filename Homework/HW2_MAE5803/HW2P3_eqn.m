function [dv] = HW2P3_eqn(t,v)

a = 1;
b = 1.5;

dv = -2*a*abs(v)*v - b*v;