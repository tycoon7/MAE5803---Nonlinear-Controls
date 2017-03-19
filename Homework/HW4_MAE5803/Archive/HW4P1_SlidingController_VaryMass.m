% Tim Coon - MAE5903 - HW#4 Part 1 Sliding Controller
% Time-vary mass, Integrate phi
clear; clc;

%% Set default figure properties
set(0,'defaultlinelinewidth',2.5)
set(0,'defaultaxeslinewidth',2.5)
set(0,'defaultpatchlinewidth',2.5)
set(0,'defaulttextfontsize',14)
set(0,'defaultaxesfontsize',14)
set(0,'defaultTextInterpreter','latex')

% Given
n = 2;
m_lims = [1 2];
alpha1_lims = [4 6];
alpha2_lims = [1 2];
dlims = [-1 1];
omega_avoid = 4.2;      % (rad/s)

% Choose parameters
m_hat = mean(m_lims);
alpha1_hat = mean(alpha1_lims);
alpha2_hat = mean(alpha2_lims);
d_hat = mean(dlims);
lambda = [2*pi*omega_avoid/3 2*pi*omega_avoid/5];
eta = [1 10];

tspan = [0 6];
X0 = [0; 0; 0];
for i1 = 1:length(lambda)
    for i2 = 1:length(eta)
        casenum = 2*(i1-1) + i2;
        [t,X] = ode45(@slidingEOM_VaryMass,tspan,X0,[],m_hat,alpha1_hat,alpha2_hat,d_hat,eta(i2),lambda(i1));
        x1 = X(:,1);
        x2 = X(:,2);
        xd = 2*sin(t);
        xd_dot = 2*cos(t);
        x1_tilde = x1 - xd;
        % Calc s and phi again (I haven't found a better way to do this yet)
        clear s phi u Fd
        for i3 = 1:length(t)
            [~,s(i3),phi(i3),u(i3),Fd(i3)] = slidingEOM_VaryMass(t(i3),X(i3,:),m_hat,alpha1_hat,alpha2_hat,d_hat,eta(i2),lambda(i1));
        end
        x_tilde_bound = Fd/lambda(i1)^n;
        %% Plots
        figure(casenum)
        suptitle(['$\lambda = $' num2str(lambda(i1)) ', $\eta = $' num2str(eta(i2))]);
        % Dynamics
        subplot(411)
        plot(t,xd,t,x1)
        legend('Desired','Sumulated','location','northeast')
        xlabel('Time'); ylabel('Position');

        % s-Dynamics
        subplot(412)
        plot(t,s,'b',t,phi,'r--',t,-phi,'r--')
        title('s-dynamics')
        xlabel('Time'); ylabel('s');

        % Error Plot
        subplot(413)
        plot(t,x1_tilde,t,x_tilde_bound,'r--',t,-x_tilde_bound,'r--');
        title('Position Error')
        xlabel('Time'); ylabel('$\widetilde{x}_1$');

        % Control Input
        subplot(414)
        plot(t,u);
        title('Control Input')
        xlabel('Time'); ylabel('$u$');
    end
end