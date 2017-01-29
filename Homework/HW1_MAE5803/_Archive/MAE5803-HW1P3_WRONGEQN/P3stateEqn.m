function [dx] = P3stateEqn(t, x, mu)
%P3stateEqn contains state eqn for MAE5803 HW1 P3
% 
dx = zeros(2,1);
dx(1) = x(2);
dx(2) = -x(1) - (mu-x(1)^2)*x(2);