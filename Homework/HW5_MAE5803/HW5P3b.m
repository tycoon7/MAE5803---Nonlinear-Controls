%% MAE5803 - HW#5 Part 3b Adaptive Controller
function HW5P3b()

m1 = 1; l1 = 1; me = 2; de = pi/6; I1 = 0.12; lc1 = .5; Ie = .25; lce = .6;
Lambda = 20*eye(2);
Kd = 100*eye(2);
P = diag([0.6,0.1,0.1,0.06]);


% a(1) = I1 + m1*lc1^2 + Ie + me*lce^2 + me*l1^2;
% a(2) = Ie + me*lce^2;
% a(3) = me*l1*lce*cos(de);
% a(4) = me*l1*lce*sin(de);

% Initial Conditions
tspan = [0 1];
X0 = [1,0,0,0,0,1,0,0];

[t,X] = ode45(@EOM,tspan,X0,[],Lambda,Kd,P);

for i = 1:length(t)
    [~,tau(:,i),q_err(:,i)] = EOM(t(i),X(i,:)',Lambda,Kd,P);
end

figure(1)
subplot(221)
plot(t,rad2deg(q_err(1,:)))
xlabel('Position Error 1 (deg)'); ylabel('Time (s)')
subplot(222)
plot(t,rad2deg(q_err(1,:)))
xlabel('Position Error 2 (deg)'); ylabel('Time (s)')
subplot(223)
plot(t,tau(1,:))
xlabel('Control Torque 1'); ylabel('Time (s)')
subplot(224)
plot(t,tau(1,:))
xlabel('Control Torque 1'); ylabel('Time (s)')
end
%%
function [dx,tau,q_err] = EOM(t,x,Lambda,Kd,P)
dx = zeros(size(x));
q = [x(1); x(2)];
q_d = [x(3); x(4)];
a = x(5:8);
qd = [1-exp(-t); 2*(1-exp(-t))];
qd_d = [exp(-t); 2*exp(-t)];
qd_dd = [-exp(-t); -2*exp(-t)];
q_err = q - qd;
q_err_d = q_d - qd_d;

qr_d = qd_d - Lambda*q_err;
qr_dd = qd_dd - Lambda*q_err_d;

H(1,1) = a(1) + 2*a(3)*cos(q(2)) + 2 * a(4)*sin(q(2));
H(1,2) = a(2) + a(3)*cos(q(2)) + a(4)*sin(q(2));
H(2,1) = H(1,2);
H(2,2) = a(2);
h = a(3)*sin(q(2)) - a(4)*cos(q(2));

C(1,1) = -h*q_d(2);
C(1,2) = -h*(q_d(1)+q_d(2));
C(2,1) = h*q_d(1);
C(2,2) = 0;

Y(1,1) = qr_dd(1);
Y(1,2) = qr_dd(2);
Y(2,1) = 0;
Y(2,2) = qr_dd(1) + qr_dd(2);
Y(1,3) = (2*qr_dd(1) + qr_dd(2))*cos(q(2)) - (q_d(2)*qr_d(1) + q_d(1)*qr_d(2) + q_d(2)*qr_d(2))*cos(q(2));
Y(2,3) = qr_dd(1)*sin(q(2)) - q_d(1)*qr_d(1)*cos(q(2));
Y(2,4) = qr_dd(1)*sin(q(2)) - q_d(1)*qr_d(1)*cos(q(2));

s = q_err_d + Lambda*q_err;
tau = Y*a - Kd*s;

dx(1:4) = [zeros(2) zeros(2); zeros(2) inv(H)]*[0;0;tau] ...
           + [zeros(2) eye(2); zeros(2) -inv(H)*C]*x(1:4);
dx(5:8) = -P*transpose(Y)*s;
end