%% MAE 5803 - Homework #2 Problem #2
% Tim Coon: 9, February 2017
%%
clear; close all; clc;

%% Set default figure properties
set(0,'defaultlinelinewidth',2.5)
set(0,'defaultaxeslinewidth',2.5)
set(0,'defaultpatchlinewidth',2.5)
set(0,'defaulttextfontsize',14)
set(0,'defaultaxesfontsize',14)
set(0,'defaultTextInterpreter','latex')

%% Equilibrium Points and Stability
% Fo the following systems, find the equilibrium points and determine their
% stability. Indicate if the stability is asymptotic and if it is global.
%
% $$ \dot{x} = -x^3 + \sin^{4}(x) $$
%
% $$ \dot{x} = (5-x)^5 $$
%
% $$ \ddot{x} + \dot{x}^5 + x^7 = x^2\sin^{8}(x)\cos^2(3x) $$
%
% $$ \ddot{x} + (x-1)^4\dot{x}^7 + x^5 = x^3\sin^{3}(x) $$
%
% $$ \ddot{x} + (x-1)^2\dot{x}^7 + x = \sin\frac{\pi x}{2} $$
%

%% Eqn #1:
% First-order state equation
%
% $$ \dot{x} = -x^3 + \sin^{4}(x) $$
%
% This system has an equilibrium point at $x=0$. Apply Theorem 3.3 to find 
% it is a globally asymptotically stable. $\dot{V}(x)$ is negative definite
% because $x^4 > x\sin^4(x)$
%
% # $$ V(\mathbf{x}) > 0 \quad \forall \quad \mathbf{x} \neq \mathbf{0} $$
% # $$ \dot{V}(\mathbf{x}) < 0 \quad \forall \quad \mathbf{x} \neq \mathbf{0} $$
% # $$ V(\mathbf{x}) \rightarrow \infty $$ as $$ \|\mathbf{x}\| \rightarrow \infty $$
%
% The Lyapunov function is:
%
% $$ V = x^2 $$
%
% $$ \dot{V}(x) = 2x\dot{x} = 2x(-x^3+\sin^4(x)) \leq 0 $$

figure()
ezplot('-x^3 + sin(x)^4')
xlabel('x'); ylabel('dx');
figure()
ezplot('2*x*(-x^3+sin(x)^4)')
xlabel('x'); ylabel('dV/dt');


%% Eqn #2:
% First-order state equation
%
% $$ \dot{x} = (5-x)^5 $$
%
% This system has an equilibrium point at $x=5$. Perform a change of
% variables to find stability about the equilibrium point
%
% $$ y = 5 - x $$
%
% $$ \dot{y} = -y^5 $$
%
% The Lyapunov function is:
%
% $$ V = y^2 $$
%
% $$ \dot{V}(y) = 2y\dot{y} = -2yy^5 = -2y^6 $$
%
% Using Theorem 3.3 as before, the equilbrium point is found to be globally
% asymptotically stable
%

%% Eqn #3:
%
% $$ \ddot{x} + \dot{x}^5 + x^7 = x^2\sin^8(x)\cos^2(3x) $$
%
% $$ k(x) = x^7-x^2\sin^8(x)\cos^2(3x) $$
%
% $$ \ddot{x} + \dot{x}^5 + k(x) = 0 $$
%
% The Lyapunov function is:
%
% $$ V(\mathbf{x}) = \frac{1}{2}\dot{x}^2+\int_0^x k(\xi)d\xi $$
%
% $$
% \begin{array}{cl}
% \dot{V}(\mathbf{x}) &= \dot{x}\ddot{x}+k(x)\dot{x} \\
% &= \dot{x}\ddot{x} + k(x)\dot{x} \\
% &= \dot{x}(-\dot{x}^5 - k) + k(x)\dot{x} \\
% &= -\dot{x}^6
% \end{array}
% $$
%
% From Theorem 3.3:
%
% # $V(\mathbf{x})$ is positive definite. The first term is squared and the
% second is found to be positive (except at zero) by integrating in MATLAB.
% # $\dot{V}(\mathbf{x})$ is negative definite according to definition 3.7
%  and the above simplification, $\dot{V}(\mathbf{x})=-\dot{x}^6$.
% # $V(\mathbf{x})$ is radially unbounded. Both terms increase
% monotonically.
%
% The origin is a globally asymptotically stable equilibrium point and is
% the only equilibrium point.
%
HW2P2_plotPhasePortrait(3,[0 10],[-1 1],[-1 1],'System \#3')

figure()
syms x
k = x^7 - x^2*sin(x)^8*cos(3*x)^2;
ezplot(int(k))
title('Eqn #3, Integral of k(x)')

%% Eqn #4:
%
% $$ \ddot{x} + (x-1)^4\dot{x}^7 + x^5 = x^3\sin^3(x) $$
%
% $$ k(x) = x^5-x^3\sin^3(x) $$
%
% $$ \ddot{x} + (x-1)^4\dot{x}^7 + k(x) = 0 $$
%
% The Lyapunov function is:
%
% $$ V(\mathbf{x}) = \frac{1}{2}\dot{x}+\int_0^x k(\xi)d\xi $$
%
% $$
% \begin{array}{cl}
% \dot{V}(\mathbf{x}) &= \dot{x}\ddot{x}+k(x)\dot{x} \\
% &= \dot{x}(-(x-1)^4\dot{x}^7 - k) + k(x)\dot{x} \\
% &= -(x-1)^4\dot{x}^8
% \end{array}
% $$
%
% From Theorem 3.3:
%
% # $V(\mathbf{x})$ is positive definite. The first term is squared and the
% second is found to be positive (except at zero) by integrating in MATLAB.
% # $\dot{V}(\mathbf{x})$ is negative definite according to definition 3.7
% and the above simplification, $\dot{V}(\mathbf{x})=-\dot{x}^6$.
% # $V(\mathbf{x})$ is radially unbounded. Both terms increase
% monotonically.
%
% The origin is a globally asymptotically stable equilibrium point and is
% the only equilibrium point.
%
HW2P2_plotPhasePortrait(4,[0 20],[-2 2],[-2 2],'System \#4')

figure()
syms x
k = x^5 - x^3*sin(x)^3;
ezplot(int(k))
title('Eqn #4, Integral of k(x)')

%% Eqn #5:
%
% $$ \ddot{x} + (x-1)^2\dot{x}^7 + x = \sin(\frac{\pi x}{2}) $$
%
% $$ k(x) = x - \sin(\frac{\pi x}{2}) $$
%
% $$ \ddot{x} + (x-1)^2\dot{x}^7 + k(x) = 0 $$
%
% The Lyapunov function is:
%
% $$ V(\mathbf{x}) = \frac{1}{2}\dot{x}^2+\int_0^x k(\xi)d\xi $$
%
% $$
% \begin{array}{cl}
% \dot{V}(\mathbf{x}) &= \dot{x}\ddot{x}+k(x)\dot{x} \\
% &= \dot{x}(-(x-1)^2\dot{x}^7 - k(x)) + k(x)\dot{x} \\
% &= -(x-1)^2\dot{x}^8
% \end{array}
% $$
%
% From Theorem 3.4:
%
% # $V(\mathbf{x}) \rightarrow \infty$ as $||x||\rightarrow \infty$ This is
% typical of energy functions.
% # $\dot{V}(\mathbf{x})$ is negative semidefinite over the entire state 
% space as evidenced by the preceeding simplification.
% # R composes all points satisfying $\dot{V}(\bar{x})=0$ which is the
% union of (1,u) and (v,0) for all real values u,v. 
%
% R = {\bar{x} : \dot{V}(\bar{x})=0} = (1,u) \bigcup (v,0) \forall u,v \in \R$
%
% Though the origin fits this definition, it does not fall within the
% region $\Omega_{\ell}$ defined in Theorem 3.4. It seems it should not fit
% here, but I can't figure out why. The origin is an unstable
% equilibrium point. The other two equilibrium points, (1,0) and (-1,0)
% meet the criteria above as well as those for Theorem 3.3. These are
% globally asymptotically stable equilibrium points. I tried to show this
% by finding the points where energy is zero, but I could only get the
% points (0,0), (-1.4483,0), and (1.4483,0).
%
HW2P2_plotPhasePortrait(5,[0 10],[-2 2],[-2 2],'System \#5')

figure()
syms x
k = x - sin(pi*x/2);
ezplot(int(k))
title('Eqn #5, Integral of k(x)')

figure()
syms x
y = x^2-2*x+1;
ezplot(y)

