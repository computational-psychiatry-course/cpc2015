function generate_data()
%% Generate data for fixed set of parameters. 
%
% Input
%
% Output
%
% aponteeduardo@gmail.com
% copyright (C) 2015
%

rng('shuffle');

NTRIALS = 300;


% Expected value of A

vA = 3.5;
sA = 2.0;

% Expected value of B

vB = 2.4;
sB = 1.0;

% Fixed value of alpha and beta

sjA = 2.0;
sjB = 2.0;

alpha = 0.05;
beta = 1.5;

theta = [alpha, beta];

ptheta = struct('vA', vA, 'sA', sA, 'vB', vB, 'sB', sB, 'vA0', sjA, ...
    'vB0', sjB);

[y, u, vS, jA, jB] = simulation(NTRIALS, theta, ptheta);

fname = mat_fname();
save(fname, 'y', 'u', 'vS', 'jA', 'jB', 'alpha', 'beta');

end % generate_datai

function [y, u, vS, jA, jB] = simulation(ntrials, theta, ptheta)
% Makes the simulation

% Codes
A = 0;
B = 1;


alpha = theta(1);
beta = theta(2);

sjA = ptheta.vA0;
sjB = ptheta.vB0;

vA = ptheta.vA;
sA = ptheta.sA;

vB = ptheta.vB;
sB = ptheta.sB;

y = zeros(ntrials, 1);
u = zeros(ntrials, 1);

% Structure of the values
vS = zeros(ntrials, 1)
jA = zeros(ntrials, 1)
jB = zeros(ntrials, 1)

for i = 1:ntrials
    pA = exp(beta * sjA) / (exp(beta * sjA) + exp(beta * sjB));

    vS(i) = pA;
    jA(i) = sjA;
    jB(i) = sjB;

    if  pA > rand
        y(i) = A;
        u(i) = vA + sA * randn;
        sjA = sjA + alpha * (u(i) - sjA);
    else
        y(i) = B;
        u(i) = vB + sB * randn;
        sjB = sjB + alpha * (u(i) - sjB);
    end
end

end

function [fname] = mat_fname()
%% Name of the file to store

fname = 'simulation.mat';
tdir = fullfile('..', 'dump');

if ~exist(tdir)
    mkdir(tdir);
end

tdir = fullfile(tdir, 'simulations');

if ~exist(tdir)
    mkdir(tdir);
end

fname = fullfile(tdir, fname);

end % mat_fname
