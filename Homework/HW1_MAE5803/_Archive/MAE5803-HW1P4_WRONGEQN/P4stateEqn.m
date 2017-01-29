function [dx] = P4stateEqn(t, x)
%P4stateEqn contains state eqn for MAE5803 HW1 P4
% 
dx = zeros(2,1);
dx(1) = -x(2);
dx(2) = x(1) - (1-x(1)^2)*x(2);

%% This is actually the Van der Pol Equation
%  "It is an equation describing self-sustaining oscillations in which
%  energy is fed into small oscillations and removed from large 
%  oscillations." -http://mathworld.wolfram.com/vanderPolEquation.html
% dx = zeros(2,1);
% dx(1) = x(2);
% dx(2) = -x(1) + mu*(1-x(1)^2)*x(2);