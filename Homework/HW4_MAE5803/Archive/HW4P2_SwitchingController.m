% Tim Coon - MAE5903 - HW#4 Part 2 Switching Controller
clear; close all; clc;

%% Set default figure properties
set(0,'defaultlinelinewidth',2.5)
set(0,'defaultaxeslinewidth',2.5)
set(0,'defaultpatchlinewidth',2.5)
set(0,'defaulttextfontsize',14)
set(0,'defaultaxesfontsize',14)
set(0,'defaultTextInterpreter','latex')

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
X0 = [0; 0; 0];
[t,X] = ode45(@P2switchingEOM,tspan,X0,[],alpha1_hat,alpha2_hat,eta,lambda);
x1 = X(:,1);
x2 = X(:,2);
u = X(:,3);
xd = 2*sin(t);
xd_dot = 2*cos(t);
x1_tilde = x1 - xd;
x2_tilde = x2 - xd_dot;
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

