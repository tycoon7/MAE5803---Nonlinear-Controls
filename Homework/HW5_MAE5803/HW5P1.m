%% MAE5803 - HW#5 Part 1 Adaptive Controller
function HW5P1(p,lambda,k)

% Choose parameters
% p = 1;
P = p*eye(2);
% lambda = 2;
% k = 1;

% Given
a1 = 2;
a2 = 5;

% Integrate
tspan = [0 20];
X0 = zeros(1,5);
[t,X] = ode45(@EOM,tspan,X0,[],a1,a2,P,lambda,k);

% Plot
xd = sin(0.8*t);
x1 = X(:,1);
a = [a1 a2];
a_hat = [X(:,4) X(:,5)];
fh = figure(1);
set(fh,'Position',[0 0 799 1089])
suptitle(['HW1 Problem #1' '   p = ' num2str(p) ', lam = ' num2str(lambda) ', k = ' num2str(k)]);
% Dynamics
subplot(211)
plot(t,xd,t,x1)
legend('Desired','Sumulated','location','southeast')
xlabel('Time'); ylabel('Position');
% Parameter Estimate
subplot(212)
hold on
plot(t,a1*ones(size(t)),'b')
plot(t,a2*ones(size(t)),'--r')
plot(t,a_hat(:,1),'b')
plot(t,a_hat(:,2),'--r')

title('Parameter Estimates') 
xlabel('Time'); ylabel('Value');

end

%% EOM
function [dx] = EOM(t,x,a1,a2,P,lambda,k)
dx = zeros(size(x));
x1 = x(1);
x2 = x(2);
x3 = x(3);
a1_hat = x(4);
a2_hat = x(5);

xd     = sin(0.8*t);
xd_d   = 0.8*cos(0.8*t);
xd_dd  = -0.64*sin(0.8*t);
xd_ddd = -0.512*cos(0.8*t);

xt    = x1 - xd
xt_d  = x2 - xd_d;
xt_dd = x3 - xd_dd;

s = xt_dd + 2*lambda*xt_d + lambda^2*xt;
xr_ddd = xd_ddd - 2*lambda*xt_dd - lambda^2*xt_d;

gamma = [x2^2 sin(2*x1)];
a_hat = [a1_hat a2_hat]';
u = xr_ddd + gamma*a_hat - k*s;
da_hat = -P*transpose(gamma)*s;

dx(1) = x2;
dx(2) = x3;
dx(3) = u - a1*x2^2 - a2*sin(2*x1);
dx(4) = da_hat(1);
dx(5) = da_hat(2);

end

%% Plots
% function [] = makeplots()
%     fh = figure();
%     set(fh,'Position',[0 0 799 1089])
%     suptitle(['$\eta = $' num2str(eta(cnt))]);
%     % Dynamics
%     subplot(411)
%     plot(t,xd,t,x1)
%     legend('Desired','Sumulated','location','southeast')
%     xlabel('Time'); ylabel('Position');
%     % Parameter Estimate
%     subplot(412)
%     plot(t,s)
%     title('s-dynamics')
%     xlabel('Time'); ylabel('s');
% end