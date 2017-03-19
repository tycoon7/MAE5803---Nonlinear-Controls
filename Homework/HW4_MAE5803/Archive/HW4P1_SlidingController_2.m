% function HW4P1_SlidingController_2

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
lambda = 2*pi*omega_avoid/3;

tspan = [0 10];
X0 = [0; 0];
for i = 1:length(eta)
    [t,X] = ode45(@EOM,tspan,X0,[],m,alpha1_hat,alpha2_hat,d_hat,eta(i),lambda);
    x1 = X(:,1);
    x2 = X(:,2);
    xd = 2*sin(t);
    xd_dot = 2*cos(t);
% %     a1 = 5 + cos(t);
% %     a2 = 1 + abs(sin(2*t));
% %     d = cos(1.3*t);
% %     fd = (-1/m).*((a1 + a2.*cos(xd).^2).*abs(xd_dot).*xd_dot + d);
% %     fd_hat = (-1/m).*((alpha1_hat + alpha2_hat.*cos(xd).^2).*abs(xd_dot).*xd_dot + d_hat);
% %     Fd = abs(fd-fd_hat);
% %     kd = Fd + eta(i);
%     phi = 0.1*ones(length(t));
%     s = x2 - xd_dot + lambda*(x1-xd);
%     s = X(:,3);
%     phi = X(:,4);

    %% Plots
    figure(i)
    suptitle(['$\eta = $' num2str(eta(i))]);
    % Dynamics
    subplot(311)
    plot(t,xd,t,x1)
    legend('Desired','Sumulated','location','southeast')
    xlabel('time'); ylabel('position');

    % Sliding Surface
    subplot(312)
    plot(x1-xd,x2-xd_dot,x1-xd,-lambda*(x1-xd))
    legend('s-dynamics','sliding surface','location','southeast')
    xlabel('$\widetilde{x}_1$'); ylabel('$\widetilde{x}_2$');
    
    % s and phi
    subplot(313)
    plot(t,s,'b',t,phi,'--r',t,-phi,'--r')
    legend('s','BL','location','southeast')
    xlabel('$\widetilde{x}_1$'); ylabel('$\widetilde{x}_2$');
end

% end

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
fd = (-1/m)*((a1 + a2*cos(xd)^2)*abs(xd_dot)*xd_dot + d);
b = 1/m;
f_hat = (-1/m)*((a1_hat + a2_hat*cos(x1)^2)*abs(x2)*x2 + d_hat);
fd_hat = (-1/m)*((a1_hat + a2_hat*cos(xd)^2)*abs(xd_dot)*xd_dot + d_hat);
F = max(abs(f-f_hat));
Fd = abs(fd-fd_hat);
k = F + eta;
kd = Fd + eta;
phi = 0.1;
phi_dot = 0;
s = x2 - xd_dot + lambda*(x1-xd);
u_hat = -f_hat + xd_dd - lambda*(x2-xd_dot);
if abs(s) >= phi
    u =  u_hat - (k-phi_dot)*sign(s);
else
    u = u_hat - (k-phi_dot)*(s/phi);
end
    
dx(1) = x2;
dx(2) = f + b*u;

assignin('caller','s_caller',s);
evalin('caller','if ~exist(''s'') s = s_caller; else s(end+1) = s_caller; end');
end