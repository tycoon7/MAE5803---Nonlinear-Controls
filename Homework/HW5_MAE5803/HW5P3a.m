%% MAE5803 - HW#5 Part 3a PD Controller
function HW5P3a()

m1 = 1; l1 = 1; me = 2; de = pi/6; I1 = 0.12; lc1 = .5; Ie = .25; lce = .6;
% qd = [pi/3; pi/2];
qd = [1; 2];

a(1) = I1 + m1*lc1^2 + Ie + me*lce^2 + me*l1^2;
a(2) = Ie + me*lce^2;
a(3) = me*l1*lce*cos(de);
a(4) = me*l1*lce*sin(de);

% Initial Conditions
tspan = [0 1];
X0 = zeros(4,1);

[t,X] = ode45(@EOM,tspan,X0,[],a,qd);

for i = 1:length(t)
    [~,tau(:,i),q_err(:,i)] = EOM(t(i),X(i,:)',a,qd);
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

function [dx,tau,q_err] = EOM(t,x,a,qd)
q1 = x(1);
q2 = x(2);
q1_dot = x(3);
q2_dot = x(4);

H(1,1) = a(1) + 2*a(3)*cos(q2) + 2 * a(4)*sin(q2);
H(1,2) = a(2) + a(3)*cos(q2) + a(4)*sin(q2);
H(2,1) = H(1,2);
H(2,2) = a(2);
h = a(3)*sin(q2) - a(4)*cos(q2);

C(1,1) = -h*q2_dot;
C(1,2) = -h*(q1_dot+q2_dot);
C(2,1) = h*q1_dot;
C(2,2) = 0;


q_err = [q1; q2] - qd;
Kd = 100*eye(2); Kp = 20*Kd;
tau = -Kp*q_err - Kd*[q1_dot; q2_dot];

dx = [zeros(2) zeros(2); zeros(2) inv(H)]*[0;0;tau] ...
        + [zeros(2) eye(2); zeros(2) -inv(H)*C]*x;
end