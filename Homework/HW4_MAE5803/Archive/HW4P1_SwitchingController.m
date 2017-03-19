% Tim Coon - MAE5903 - HW#4 Part 1 Switching Controller
clear; clc;

%% Set default figure properties
set(0,'defaultlinelinewidth',2.5)
set(0,'defaultaxeslinewidth',2.5)
set(0,'defaultpatchlinewidth',2.5)
set(0,'defaulttextfontsize',14)
set(0,'defaultaxesfontsize',14)
set(0,'defaultTextInterpreter','latex')

% Given
m = 1;
alpha1_lims = [4 6];
alpha2_lims = [1 2];
dlims = [-1 1];
omega_avoid = 4.2;      % (rad/s)
eta = [1 10];
xd = @(t) 2*sin(t);

% Choose parameters
alpha1_hat = mean(alpha1_lims);
alpha2_hat = mean(alpha2_lims);
d_hat = mean(dlims);
lambda = 2*pi*omega_avoid/3;

tspan = [0 6];
X0 = [0; 0];
for i = 1:length(eta)
    [t,X] = ode45(@switchingEOM,tspan,X0,[],m,alpha1_hat,alpha2_hat,d_hat,eta(i),lambda);
    x1 = X(:,1);
    x2 = X(:,2);
    xd = 2*sin(t);
    xd_dot = 2*cos(t);
    x1_tilde = x1 - xd;
    x2_tilde = x2 - xd_dot;
    % Calc s and phi again (I haven't found a better way to do this yet)
    for j = 1:length(t)
        [~,s(j),u(j)] = switchingEOM(t(j),X(j,:),m,alpha1_hat,alpha2_hat,d_hat,eta(i),lambda);
    end
    %% Plots
    fh = figure(i);
    set(fh,'Position',[0 0 799 1089])
    suptitle(['$\eta = $' num2str(eta(i))]);
    % Dynamics
    subplot(411)
    plot(t,xd,t,x1)
    legend('Desired','Sumulated','location','southeast')
    xlabel('Time'); ylabel('Position');
    
    subplot(412)
    plot(t,s)
    title('s-dynamics')
    xlabel('Time'); ylabel('s');
    
    % Sliding Surface
%     subplot(412)
%     plot(x1_tilde,x2_tilde,x1_tilde,-lambda*(x1_tilde))
%     legend('s-dynamics','sliding surface','location','northeast')
%     xlabel('$\widetilde{x}_1$'); ylabel('$\widetilde{x}_2$');
    
    % Error Plot
    subplot(413)
    plot(t,x1_tilde);
    title('Position Error')
    xlabel('Time'); ylabel('$\widetilde{x}_1$');
    
    % Control Input
    subplot(414)
    plot(t,u);
    title('Control Input')
    xlabel('Time'); ylabel('$u$');
    
%     % Phase Plot
%     subplot(312)
%     plot(x1,2*xd_dot+lambda*(x1-xd),x2,x1);
%     legend('Sliding Surface','Simulated')
%     xlabel('$x_1$'); ylabel('$x_2$');
end

