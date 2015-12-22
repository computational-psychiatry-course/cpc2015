function run_mcmcm()
%% Draws the mcmc method
%
% Input
%
% Output
%
% aponteeduardo@gmail.com
% copyright (C) 2015
%

fname = data_fname();
data = load(fname);

y = data.y;
u = data.u;

htheta.nburnin = 10000;
htheta.niter = 30000;
htheta.sigma = diag([0.1 0.1]);

ptheta.beta_mu = 0;
ptheta.beta_sigma = 3;

ptheta.alpha_a = 2;
ptheta.alpha_b = 5;

ptheta.vA0 = 2;
ptheta.vB0 = 2;

[post] = metropolis_hastings(y, u, ptheta, htheta);

fname = results_fname();

save(fname, 'post');

end % run_mcmc


function [fname] = data_fname()
% Name of the file containing the data

fname = 'simulation.mat';
dname = '../dump/simulations';

fname = fullfile(dname, fname);

end % data_fname

function [fname] = results_fname()
% Name of the file with the target results

fname = 'posteriors.mat';
dname = '../dump/posteriors/';

if ~exist(dname)
    mkdir(dname);
end

fname = fullfile(dname, fname);

end % results_fname
