%% MAE 5803 - Homework #1 Problem #3
% Tim Coon: 25, January 2017
%%
clear; close all; clc;

%% Consider the following second-order system
%
% $$ \dot{x}_1 = x_2 $$
%
% $$ \dot{x}_2 = -x_1 + (\mu - x^2_1)x_2 $$

%% a) Plot Eigenvalues
% Find the eigenvalues of the linearized system about the equilibrium point, (0,0). Express your answer in terms of $\mu$. Sketch in the complex plane the variation of the locations of these eigenvalues as $\mu$ varies from -0.5 to 0.5.
% 
%
% $$ A = \left.\frac{\partial{\bar{f}}}{\partial{\bar{x}}}\right\vert_{\bar{x}=\bar{0}} $$
%
% $$ \frac{\partial{f_1}}{\partial{x_1}} = 0            \quad
%    \frac{\partial{f_1}}{\partial{x_2}} = 1            \quad
%    \frac{\partial{f_2}}{\partial{x_1}} = -1 - 2x_1x_2 \quad
%    \frac{\partial{f_2}}{\partial{x_2}} = \mu - x^2_1 $$
%
% $$ A = \pmatrix{0&1\cr
%                 -1&\mu\cr}$$
% 
% Calculate the eigenvalues for samples of the range of $\mu$ specified
mu = [-0.5:0.25:0.5];
eValue = zeros(2,length(mu));
figure(1)
hold on
for i = 1:length(mu)
    A =  [0 1; -1 mu(i)];
    eValue(:,i) = eig(A);
    plot(real(eValue(:,i)),imag(eValue(:,i)),'*','MarkerSize',12)
end
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ylim([-1.2 1.2]);
title('Eigenvalues of Linearized System')
xlabel('$\sigma$'); ylabel('j$\omega$');
legend(strcat('\mu = ',strread(num2str(mu),'%s')),'Location','EastOutside')
hold off

%% b) Nonlinear Phase Portraits
% Draw the phase portraits of the system using MATLAB for $\mu = -0.2$, $\mu = 0$, and $\mu = 0.2$. Use -2 to 2 range of values for the horizontal and vertical axes.
%
mu = [-0.2 0 0.2];
for i = 1:length(mu)
    figure()
    hold on
    for x1 = -1.5:.75:1.5
        for x2 = -1.5:.5:1.5
            tspan = [0 5];
            x0 = [x1; x2];
            [t,x] = ode45(@P3stateEqn,tspan,x0,[],mu(i));
            h = plot(x(:,1),x(:,2));
            c = get(h,'color');
            plot(x0(1),x0(2),'+','color',c);
        end
    end
    axis([-2 2 -2 2])
    xlabel('$x_1$')
    ylabel('$x_2$')
    title(strcat('Nonlinear system phase portrait, $\mu =$ ', num2str(mu(i))))
    hold off
end


%% d) Observations
% What phenomenon do you observe as the parameter, $\mu$, varies from negative to positive? Justify your answer using Poincare-Bendixson Theorem.
%
% # If the real parts of all eigenvalues are negative, then $\bf{x} = \bf{0}$ is locally asymptotically stable
% # If the real part of at least one eigenvalue is positive, then $\bf{x} = \bf{0}$ is locally unstable
% # If the real part of at least one eigenvalue is equal to zero, then the local stability of $\bf{x} = \bf{0}$ cannot be concluded
%
% From the plot of eigenvalues, it can be seen, as $\mu$ goes from negative
% to positive, the real part of the eigenvalues moves from positive to
% negative even as the equilibrium point remains on the origin. Thus, the
% stability of origin transitions from locally asymptotically stable to
% unstable. At $\mu = 0$, the eigenvalues have real parts equal
% to zero and stability is not concluded by eigenvalue analysis, but the 
% phase portrait reveals the origin is stable in this system.
%
% Poincare-Bendixson Theorem: If a trajectory of a second-order autonomous system remains in a finite region ($\Omega$), then one of the following is true:
%
% # The trajectory goes to an equilibrium point
% # The trajectory tends to a stable limit cycle
% # The trajectory itself is a limit cycle
%
% The system having $\mu > 0$ is unstable at the origin, by Slotine-Li
% Definition 3.3.