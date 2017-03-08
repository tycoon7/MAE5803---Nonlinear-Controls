% HW3P5
function plotHW3P5
set(0,'defaultTextInterpreter','latex')
w02 = [0.67 1.33 2.0] - eps;
tspan = [0 20];

figure();

for i = 1:length(w02)
    subplot(length(w02),1,i)
    hold on
    for j = 1:2
        X0 = [0; 1];
        [t,X] = ode45(@stateEqn,tspan,X0,[],w02(i),j);
        if j == 1
            plot(t,X(:,1),'--');
        elseif j == 2
            plot(t,X(:,1),'-');
        end
    end
    ylabel('$x$')
    title(['$w_0^2$ $=$ ' num2str(w02(i)) ' $-$ $\epsilon$'])
    hold off
end
xlabel('Time')
hold off
end

%% State Equations    
function [dx] = stateEqn(t, x, w2, flag)
%P1stateEqn contains state eqn for MAE5803 HW1 P1
% flag: choose which equation to integrate
%
dx = zeros(size(x));
switch flag
    case 1
        dx(1) = x(2);
        dx(2) = w2*x(1)*sin(x(1));

    case 2
        dx(1) = x(2);
        dx(2) = w2*x(1)*sin(x(1)) - 2*x(1)^2 - x(2);
end

end