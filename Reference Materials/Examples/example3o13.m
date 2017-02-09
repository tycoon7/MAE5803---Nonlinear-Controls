% Example 3.13
function example3o13()
figure()
syms x1 x2
h = ezplot(x1^4+2*x2^2 == 10);
set(h,'linestyle','-.','Interpreter','tex')
clearvars
%%
tspan = [0,2];
figure();
hold on
for i = -5:1:5
    for j = -5:1:5
        X0 = [i; j];
        [t,X] = ode45(@EoM,tspan,X0,[],1);
        h = plot(X(:,1),X(:,2));
        c = get(h,'color');
        plot(X0(1),X0(2),'+','color',c);
    end
end
axis([-5 5 -5 5])
axis equal
xlabel('$x$')
ylabel('$\dot{x}$')
title('Nonlinear system phase portrait')
clearvars
%%
tspan = [0,15];
figure();
hold on
X0 = [10^(1/4);0];
[t,X] = ode45(@EoM,tspan,X0,[],2);
h = plot(X(:,1),X(:,2));
c = get(h,'color');
plot(X0(1),X0(2),'+','color',c);
axis([-5 5 -5 5])
axis equal
xlabel('$x$')
ylabel('$\dot{x}$')
title('Nonlinear system phase portrait')

end

function [dx] = EoM(t,x,flag)
dx = zeros(size(x));
switch flag
    case 1
        dx(1) = x(2) - x(1)^7*(x(1)^4+2*x(2)^2-10);
        dx(2) = -x(1)^3 - 3*x(2)^5*(x(1)^4+2*x(2)^2-10);
    case 2
        dx(1) = x(2);
        dx(2) = -x(1)^3;
end
end