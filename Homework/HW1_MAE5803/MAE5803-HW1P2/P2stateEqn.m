%% P2 State Equations
%%
function [dx] = P2stateEqn(t, x, mu)
%P2stateEqn contains state eqn for MAE5803 HW1 P2
% 

dx = zeros(2,1);
dx(1) = mu - x(1)^2;
dx(2) = -x(2);