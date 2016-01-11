function [vA, vB, pA] = posterior_trace(y, u, theta, ptheta)
%% Generates a posterior trace. 
%
% Input
%
% Output
%
% aponteeduardo@gmail.com
% copyright (C) 2015
%

A = 0;
B = 1;

alpha = atan(theta(1))/pi + 0.5;
beta = exp(theta(2));

nt = size(y, 1);

vA = zeros(nt, 1);
vB = zeros(nt, 1);
pA = zeros(nt, 1);

tA = ptheta.vA0;
tB = ptheta.vB0;

for i = 1:nt
    pA(i) = 1/(1 + exp(-beta * (tA - tB)));
    if y(i) == 0
        tA = tA + alpha * (u(i) - tA);
    elseif y(i) == 1
        tB = tB + alpha * (u(i) - tB);
    end
    vA(i) = tA;
    vB(i) = tB;
end

end % posterior_trace
