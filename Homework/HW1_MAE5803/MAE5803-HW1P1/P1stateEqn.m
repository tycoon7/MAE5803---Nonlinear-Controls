%% P1 State Equations
%%
function [dx] = P1stateEqn(t, x, flag)
%P1stateEqn contains state eqn for MAE5803 HW1 P1
% flag: choose which equation to integrate
%
dx = zeros(2,1);
if flag == 1
    % nonlinear state equation
    dx(1) = x(2);
    dx(2) = -0.6*x(2) - 3*x(1) - x(1)^2;
    
elseif flag == 2
    % linearized about the origin
    dx(1) = x(2);
    dx(2) = -0.6*x(2) - 3*x(1);
    
elseif flag == 3
    % linearized about (-3,0)
    z = x + [3; 0];
    dz = dx;
    z(1) = x(1) + 3;
    z(2) = x(2);
    dz(1) = z(2);
    dz(2) = -0.6*z(2) + 3*z(1);
    dx(1) = dz(1);
    dx(2) = dz(2);
end