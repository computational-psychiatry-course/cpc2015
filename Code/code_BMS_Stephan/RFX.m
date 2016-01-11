function [alpha, exp_r, xp, pxp, bor] = RFX(file_name)

% #####################################################################
% Simple demo routine of how to implement a random effects BMS analysis.
% For more information on random effects BMS, see:
%   Stephan et al. 2007, NeuroImage 46:1004–1017
%   Rigoux et al. 2014, NeuroImage 84:971–985
% 
% ARGUMENTS:
% IN:
%   file_name:  name of MATLAB file with matrix F containing log-evidences
%               (dimensions: subjeccts x models)
% OUT: 
%   alpha:      vector of model probabilities
%   exp_r:      expectation of the posterior p(r|y)
%   xp:         exceedance probabilities
%   pxp:        protected exceedance probabilities
%   bor:        Bayes Omnibus Risk (probability that model frequencies 
%               are equal)
% 
% Klaas Enno Stephan, December 2015
% #####################################################################

% load matrix of log evidences with dimensions N x M:
% ===================================================
load (file_name);
% N: number of subjects
N = size(F,1);
% M: number of models
M = size(F,2);

% call spm_BMS
% =================================================
[alpha, exp_r, xp, pxp, bor] = spm_BMS (F, 1e6, 1, 0, 1, ones(1,M))

return
