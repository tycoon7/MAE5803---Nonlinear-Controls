function HW4P1_SwitchingController

set(0,'defaulttextinterpreter','latex')

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
lambda = 2*pi*omega_avoid/5;

tspan = [0 10];
X0 = [0; 0];
for i = 1:length(eta)
    [t,X] = ode45(@EOM,tspan,X0,[],m,alpha1_hat,alpha2_hat,d_hat,eta(i),lambda);
    x1 = X(:,1);
    x2 = X(:,2);
    xd = 2*sin(t);
    xd_dot = 2*cos(t);
    x1_tilde = x1 - xd;
    x2_tilde = x2 - xd_dot; 

    %% Plots
    figure(i)
    suptitle(['$\eta = $' num2str(eta(i))]);
    % Dynamics
    subplot(311)
    plot(t,xd,t,x1)
    legend('Desired','Sumulated','location','southeast')
    xlabel('time'); ylabel('$x_1$');
    
    % Error Plot
    subplot(312)
    plot(t,x1_tilde);
    legend('Position Error')
    xlabel('time'); ylabel('$\widetilde{x}_1$');

    % Sliding Surface
    subplot(313)
    plot(x1_tilde,x2_tilde,x1_tilde,-lambda*(x1_tilde))
    legend('s-dynamics','sliding surface','location','northeast')
    xlabel('$\widetilde{x}_1$'); ylabel('$\widetilde{x}_2$');
    
%     % Phase Plot
%     subplot(312)
%     plot(x1,2*xd_dot+lambda*(x1-xd),x2,x1);
%     legend('Sliding Surface','Simulated')
%     xlabel('$x_1$'); ylabel('$x_2$');
end

end

%% Equation of Motion
function [dx] = EOM(t,x,m,a1_hat,a2_hat,d_hat,eta,lambda)
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