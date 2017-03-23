%% MAE5903 - HW#4 Part 1 Switching Controller
function HW4P1_ab()

% Given
m = 1;
alpha1_lims = [4 6];
alpha2_lims = [1 2];
dlims = [-1 1];
omega_avoid = 4.2;      % (rad/s)
eta = [1 10];

% Choose parameters
alpha1_hat = mean(alpha1_lims);
alpha2_hat = mean(alpha2_lims);
d_hat = mean(dlims);
lambda = 2*pi*omega_avoid/3;

tspan = [0 6];
X0 = [1; 0];
for i = 1:length(eta)
    [t,X] = ode45(@switchingEOM,tspan,X0,[],m,alpha1_hat,alpha2_hat,d_hat,eta(i),lambda);
    x1 = X(:,1);
    xd = 2*sin(t);
    x1_tilde = x1 - xd;
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
end
end

%% EOM
function [dx, s, u] = switchingEOM(t,x,m,a1_hat,a2_hat,d_hat,eta,lambda)
dx = zeros(size(x));
x1 = x(1);
x2 = x(2);
xd = 2*sin(t);
xd_dot = 2*cos(t);
xd_dd = -2*sin(t);

a1 = 5 + cos(t);
a2 = 1 + abs(sin(2*t));
d = cos(1.3*t);
f = (-1/m)*((a1 + a2*cos(x1)^2)*abs(x2)*x2 + d);
b = 1/m;
f_hat = (-1/m)*((a1_hat + a2_hat*cos(x1)^2)*abs(x2)*x2 + d_hat);
F = abs(f-f_hat);
k = F + eta;
s = x2 - xd_dot + lambda*(x1-xd);
u = -f_hat + xd_dd - lambda*(x2-xd_dot) - k*sign(s);

dx(1) = x2;
dx(2) = f + b*u;
end
