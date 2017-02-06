%%
function HW1P2_plotPhasePortrait(eqnum,tspan,xLimits,yLimits,plotTitle)
% PLOTPHASEPORTRAIT plots the phase portrait
figure(eqnum);
hold on
for i = linspace(xLimits(1),xLimits(2),5)
    for j = linspace(yLimits(1),yLimits(2),5)
        X0 = [i; j];
        [t,X] = ode45(@stateEqn,tspan,X0,[],eqnum);
        h = plot(X(:,1),X(:,2));
        c = get(h,'color');
        plot(X0(1),X0(2),'+','color',c);
    end
end
axis([-2 2 -2 2])
axis equal
xlabel('$x$')
ylabel('$\dot{x}$')
title(plotTitle)
hold off
end

%% State Equations    
function [dx] = stateEqn(t, x, flag)
%P1stateEqn contains state eqn for MAE5803 HW1 P1
% flag: choose which equation to integrate
%
dx = zeros(2,1);
if flag == 1
    dx(1) = -x(1)^3 + sin(x(1))^4;
    dx(2) = 0;
    
elseif flag == 2
    dx(1) = (5-x(1))^5;
    dx(2) = 0;
    
elseif flag == 3   
    dx(1) = x(2);
    dx(2) = x(1)^2*sin(x(1))^8*cos(3*x(1))^2 - x(1)^7 - x(2);
    
elseif flag == 4
    dx(1) = x(2);
    dx(2) = x(1)^3*sin(x(1))^3 - (x(1)-1)^4*x(2)^7 - x(1)^5;
    
elseif flag == 5
    dx(1) = x(2);
    dx(2) = sin(pi*x(1)/2) - (x(1)-1)^2*x(2)^7 - x(1);
end
end