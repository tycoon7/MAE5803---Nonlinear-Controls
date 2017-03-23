%% MAE5803 - HW#4 Part 2 Switching Controller
function HW4P2()

%% Given
alpha1_lims = [-1 1];
alpha2_lims = [-1 5];

%% Choose parameters
alpha1_hat = mean(alpha1_lims);
alpha2_hat = mean(alpha2_lims);
lambda = 2;
eta = 1;
tspan = [0 6];

%% Integrate
X0 = [1; 0; 0];
[t,X] = ode45(@P2switchingEOM,tspan,X0,[],alpha1_hat,alpha2_hat,eta,lambda);
x1 = X(:,1);
u = X(:,3);
xd = 2*sin(t);
x1_tilde = x1 - xd;

% Calc s and phi again (I haven't found a better way to do this yet)
for j = 1:length(t)
    [~,s(j),v(j)] = P2switchingEOM(t(j),X(j,:),alpha1_hat,alpha2_hat,eta,lambda);
end

%% Plots
figure('Position',[0 0 799 1089])
suptitle(['$\lambda = $' num2str(lambda) ', $\eta = $' num2str(eta)]);
% Dynamics
subplot(511)
plot(t,xd,t,x1)
legend('Desired','Sumulated','location','northeast')
xlabel('Time'); ylabel('Position');

subplot(512)
plot(t,s)
title('s-dynamics')
xlabel('Time'); ylabel('s');

% Error Plot
subplot(513)
plot(t,x1_tilde);
title('Position Error')
xlabel('Time'); ylabel('$\widetilde{x}_1$');

% Control Input
subplot(514)
plot(t,v);
title('Control Input')
xlabel('Time'); ylabel('$u$');

% Filtered Control Input
subplot(515)
plot(t,u);
title('Filtered Control Input')
xlabel('Time'); ylabel('$v$');
end

%% EOM
function [dx, s, v] = P2switchingEOM(t,x,a1_hat,a2_hat,eta,lambda)
dx = zeros(size(x));
x1 = x(1);
x2 = x(2);
u = x(3);
xd = 2*sin(t);
xd_dot = 2*cos(t);
xd_dd = -2*sin(t);

a1 = sin(t);
a2 = 3*cos(t) + 2;
f = -a1*abs(x1)*x2^2 - a2*x1^3*cos(2*x1);
b = 1;
f_hat = -a1_hat*abs(x1)*x2^2 - a2_hat*x1^3*cos(2*x1);
F = abs(f-f_hat);
k = F + eta;
s = x2 - xd_dot + lambda*(x1-xd);
v = -f_hat + xd_dd - lambda*(x2-xd_dot) - k*sign(s);

dx(1) = x2;
dx(2) = f + b*v;
dx(3) = 0.2*(v - u);
end
