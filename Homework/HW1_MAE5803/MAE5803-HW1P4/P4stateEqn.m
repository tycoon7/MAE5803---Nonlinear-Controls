%% P4 State Equations
%%
function [dx] = P4stateEqn(t, x)
%P4stateEqn contains state eqn for MAE5803 HW1 P4
% 
dx = zeros(2,1);
dx(1) = -x(2);
dx(2) = x(1) - (1-x(1)^2)*x(2);

%% ??
% Here is the Van der Pol Equation, according to one definition:
% "It is an equation describing self-sustaining oscillations in which
% energy is fed into small oscillations and removed from large 
% oscillations." -http://mathworld.wolfram.com/vanderPolEquation.html
%
% $$ \dot{x}_1 = x_2 $$
%
% $$ \dot{x}_2 = -x_1 + (1 - x^2_1)x_2 $$