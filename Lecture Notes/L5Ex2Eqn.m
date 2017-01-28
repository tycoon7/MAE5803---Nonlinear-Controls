function [dx] = L5Ex2Eqn(t, x)
%L5Ex2Eqn Pendulum with friction
% 

dx = zeros(2,1);
dx(1) = x(2);
dx(2) = -sin(x(1)) - 0.3*x(2);