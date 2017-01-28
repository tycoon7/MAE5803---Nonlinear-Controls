clear; close all; clc;

tspan = [0 4];
figure();
hold on
for x1 = -5:1:5
    for x2 = -3:1:3
        X0 = [x1; x2];
        [t,X] = ode45(@L5Ex2Eqn,tspan,X0,[]);
        h = plot(X(:,1),X(:,2));
        c = get(h,'color');
        plot(X0(1),X0(2),'+','color',c);
    end
end
axis([-5 5 -5 5])
xlabel('$x_1$')
ylabel('$x_2$')
title('Pendulum With Friction')
hold off