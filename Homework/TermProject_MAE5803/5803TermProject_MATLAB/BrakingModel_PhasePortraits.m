% Braking Model
clear; close all; clc;
%% Set default figure properties
set(0,'defaultlinelinewidth',2.5)
set(0,'defaultaxeslinewidth',2.5)
set(0,'defaultpatchlinewidth',2.5)
set(0,'defaulttextfontsize',14)
set(0,'defaultaxesfontsize',14)
set(0,'defaultTextInterpreter','latex')


%% Given
g = 9.81;           % (m/s^2) gravitational constant
nu = 15;            % (-) vehicle to wheel inertia ratio

%% friction coefficient model
% best guess for c. These can be unknown, but bounded adaptive control
c = [1.1 10 0.5];      % (-) friction coefficient parameters
% equation determined by experiment
mu = @(s) c(1)*(1-exp(-c(2)*s)) - c(3)*s;
% find max mu and corresponding s (desired)
[s_d,mu_d] = fminbnd(@(x)-mu(x),0,1);
mu_d = abs(mu_d);
% figure()
% fplot(mu,[0 1],'linewidth',2.5)
% title('Friction Coefficient'); xlabel('Slip Variable'); ylabel('$\mu$');
% xlim([0 1]); ylim([0 1]);

%% Plot phase portrait
figure()
hold on
tspan = [0 4];
% u0 = 20;
u0 = 0:2:20;        % initial speed
wR0 = 0:2:20;       % initial wR
[M1,M2] = meshgrid(u0,wR0);
M1t = triu(M1); M2t = triu(M2);
A = cat(2,M1t,M2t);
X0 = reshape(A,[],2);
X0(find(~sum(X0,2)),:) = [];
for i1 = 1:length(X0)
    [t{i1},X{i1}] = ode45(@EOM_qCarNL_Dynamics,tspan,X0(i1,:)',[],g,c,nu,s_d,mu_d);
    u{i1} = X{i1}(:,1);
    wR{i1} = X{i1}(:,2);
    for i2 = 1:length(t{i1})
        [~,s{i1}(i2),H{i1}(i2),Y_b{i1}(i2)] = EOM_qCarNL_Dynamics(t{i1}(i2),X{i1}(i2,:),g,c,nu,s_d,mu_d);
    end
        plot(u{i1},wR{i1})
end
plot([0 20],[0 20],'k','linewidth',2.5)
wR_d = @(u_d) u_d*(1-s_d);
fplot(wR_d,[0 20],'linewidth',2.5)
axis([0 20 0 20])
% axis equal
xlabel('$u$')
ylabel('${\omega}R$')
% title('Nonlinear system phase portrait')
ax = gca; ax.YAxisLocation= 'Right';
hold off

%% Plot wheel slip over time
figure()
subplot(411)
hold on
% for i3 = 1:5:length(s)
for i3 = 65
    plot(t{i3},s{i3})
end
hold off
xlabel('Time'); ylabel('$s$');
xlim(tspan); ylim([0 1]);

% vehicle velocity over time
subplot(412)
hold on
% for i4 = 1:5:length(s)
for i4 = 65
    plot(t{i4},u{i4})
end
hold off
xlabel('Time'); ylabel('$u$');
xlim(tspan); ylim([0 20]);

% wheel velocity over time
subplot(413)
hold on
% for i4 = 1:5:length(s)
for i4 = 65
    plot(t{i4},wR{i4})
end
hold off
xlabel('Time'); ylabel('${\omega}R$');
xlim(tspan); ylim([0 20]);

% control input
subplot(414)
hold on
for i5 = 65
    plot(t{i5},Y_b{i5})
end
hold off
xlabel('Time'); ylabel('$Y_b$');
Y_bmax = max(Y_b{i5});
xlim(tspan); ylim([0 Y_bmax]);