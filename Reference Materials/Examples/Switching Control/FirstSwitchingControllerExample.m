function FirstSwitchingControllerExample
% from Slotine-Li section 7.1.3

set(0,'defaulttextinterpreter','latex')

eta = 1;
lambda = 2;
tspan = [0 10];
X0 = [1; 0];
[t,X] = ode45(@EOM,tspan,X0,[],eta,lambda);
x1 = X(:,1);
x2 = X(:,2);
xd = 2*sin(t);
xd_dot = 2*cos(t);
% s = x2 - xd_dot + lambda*(x1-xd);

%% Plots

figure(1)
% Dynamics
subplot(311)
plot(t,xd,t,x1)
legend('Desired','Sumulated')
xlabel('time'); ylabel('position');

% Phase Plot
subplot(312)
plot(x1,2*xd_dot+lambda*(x1-xd),x2,x1);
legend('Sliding Surface','Simulated')
xlabel('$x_1$'); ylabel('$x_2$');

% Sliding Surface
subplot(313)
plot(x1-xd,x2-xd_dot,x1-xd,-lambda*(x1-xd))
xlabel('$\widetilde{x}_1$'); ylabel('$\widetilde{x}_2$');
title('Sliding Surface')

end

%% Equation of Motion
function [dx] = EOM(t,x,eta,lambda)
dx = zeros(size(x));
x1 = x(1);
x2 = x(2);
xd = 2*sin(t);
xd_dot = 2*cos(t);
xd_dd = -2*sin(t);

a = 0.5*cos(t) + 1.5;
f_hat = -1.5*x2^2*cos(3*x1);
F = 0.5*x2^2*abs(cos(3*x1));
k = F + eta;
s = x2 - xd_dot + lambda*(x1-xd);
u = -f_hat + xd_dd - lambda*(x2-xd_dot) - k*sign(s);

dx(1) = x2;
dx(2) = -a*x2^2*cos(3*x1) + u;
end