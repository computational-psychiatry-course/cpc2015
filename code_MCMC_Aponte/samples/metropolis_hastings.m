function [post] = metropolis_hastings(y, u, ptheta, htheta)
%% Skeleton for implementing the metropolis hasting algorithm
%
% Input
%   y           Experimental data
%   u           Experimental design
%   ptheta      Priors of the parameters
%   htheta      Parameters of the Metropolis hastings algorithm
%
% Output
%
% aponteeduardo@gmail.com
% copyright (C) 2015
%

% This gives different random number everytime
rng('shuffle')

% Number of burn in iteration
nburnin = htheta.nburnin;

% Number of iterations use to sample
niter = htheta.niter;

% Compute the square root of the covariance for the proposal distribution
htheta.csigma = chol(htheta.sigma);

otheta = htheta.csigma * randn(size(htheta.csigma, 1), 1);
ollh = llh(y, u, otheta, ptheta);
olpp = lpp(u, otheta, ptheta);

% Samples from the posterior distribution
post = struct();
post.theta = zeros(numel(otheta), niter);
post.ljp = zeros(1, niter);
% Compute the acceptance rate
ar = 0;

for i = 1: nburnin + niter
    % Propose a new sample
    ntheta = otheta + htheta.csigma * randn(size(otheta));
    
    % Compute log likelihood conditioned on a proposed sample
    nllh = llh(y, u, ntheta, ptheta);
    % Compute log prior probability
    nlpp = lpp(u, ntheta, ptheta);

    % Probability of acceptance
    paccept = min(0, (nllh + nlpp) - (ollh + olpp));

    % If the samples is accepted keep it 
    if exp(paccept) > rand
        otheta = ntheta;
        ollh = nllh;
        olpp = nlpp;

        ar = ar + 1;
    end

    % Store your samples
    if i > nburnin
        post.ljp(i - nburnin) = ollh + olpp;
        post.theta(:, i - nburnin) = otheta;
    end

end


post.ar = ar / (nburnin + niter);

end % Metropolis hastings

function [l] = llh(y, u, theta, ptheta)
% A simple model of learning a policy

alpha = theta(1);
alpha = atan(alpha)/pi + 0.5; % Squeeze to the [0, 1] interval

beta = theta(2);
beta = exp(beta); % Make it always positive.

vA = ptheta.vA0;
vB = ptheta.vB0;

l = 0;

for i = 1:numel(y)
    if y(i) == 0 % Case where decision is A
        % Likelihood of a decision
        l = l - log(1 + exp(-beta * ( vA - vB )));
        vA = vA + alpha * (u(i) - vA);
    elseif y(i) == 1 % Case where decision is B
        % Likelihood of a decision
        l = l - log(1 + exp(-beta * ( vB - vA )));
        vB = vB + alpha * (u(i) - vB);
    end
end


end % llh

function [p] = lpp(u, theta, ptheta)
% Prior probability of the parameters

% We asssume that alpha is beta distributed
alpha = theta(1);
alpha = atan(alpha)/pi + 0.5; % Squeeze to the [0, 1] interval

p = log(betapdf(alpha, ptheta.alpha_a, ptheta.alpha_b));

% Beta is log normal distributed
beta = theta(2);
p = p + log(normpdf(beta, ptheta.beta_mu, ptheta.beta_sigma));

end % lpp
