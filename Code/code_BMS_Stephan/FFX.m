function [sF,pp,GBF,ABF] = FFX(file_name)
% #####################################################################
% Simple demo routine of how to implement a fixed effects BMS analysis.
% For more information on fixed effects BMS, see:
%   Stephan et al. 2007, NeuroImage 38:387-401
% 
% ARGUMENTS:
% IN:
%   file_name:  name of MATLAB file with matrix F containing log-evidences
%               (dimensions: subjeccts x models)
% OUT: 
%   sF:         summed log-evidences (normalised -> best model = zero)
%   pp:         posterior probabilities
%   GBF:        matrix of pairwise group Bayes factors
%   ABF:        matrix of pairwise average Bayes factors

% Klaas Enno Stephan, December 2015
% #####################################################################


% load matrix of log evidences with dimensions N x M:
% ===================================================
load (file_name);
% N: number of subjects
N = size(F,1);
% M: number of models
M = size(F,2);

%  compute posterior probabilities 
% ===================================================
sF      = sum(F); % group-wise summed log-evidences
sF      = sF - max(sF);  % normalise to avoid numerical overflow
pp      = exp(sF)./sum(exp(sF));

% plot group-wise summed log-evidences
% (equivalent to log GBF of best model compared to all others)
figure;
col =[0.6 0.6 0.6];
colormap(col);
bar(sF);
title('Log Group Bayes Factor (GBF)')
xlabel('model','FontSize',14,'FontWeight','bold')
ylabel('log GBF','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',14);

% plot posterior probability
figure;
col =[0.6 0.6 0.6];
colormap(col);
bar(pp);
title('Posterior probability')
xlabel('model','FontSize',14,'FontWeight','bold')
ylabel('posterior prob.','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',14);

% compute  group Bayes factor (GBF) and average Bayes factor (ABF) for any 
% model pair j and k
% ===================================================
GBF = zeros(M,M);
ABF = zeros(M,M);
for j = 1:M,
    for k = 1:M,
        GBF(j,k) = exp(sF(j)-sF(k));
        ABF(j,k) = GBF(j,k).^(1/N);
    end
end

% plot ABF matrix 
figure
imagesc(ABF)
colorbar
title('Average Bayes Factor (ABF)')
xlabel('model','FontSize',14,'FontWeight','bold')
ylabel('model','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',14);


return


