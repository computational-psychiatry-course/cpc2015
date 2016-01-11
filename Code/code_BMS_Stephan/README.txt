FFX.m and RFX.m are two (very simple) demonstrations of fixed effects and random effects Bayesian model selection (BMS), respectively. They can be run using any log evidence matrix that is
(i) has dimensions subjects y models,
(ii) is named "F",
(iii) is saved as .mat file.
An example F matrix is included in the file LogEvidences_SNR1_T4_N10_G4.mat. This represents a fictitious scenario of 10 subjects whose data are fitted by 4 competing models. The data result from a simulation of a two-region DCM (using model 4), with SNR=1.

FFX is stand-alone; RFX requires SPM12 (freely available at http://www.fil.ion.ucl.ac.uk/spm).


  