%% Specify SPM Folder -  
 addpath(genpath('C:\Users\rosalynj\Dropbox\CP_Zurich\spm'))
%addpath(genpath('C:\Users\rosalynj\Dropbox\CP_Zurich\spm_new'))

%% Specify Data File : Time Series
DCM.xY.Dfile =  'ffmSPM_12_0mgKetRat1';

DCM.name         = 'Old2SPM_DCM_CMM_NMDA_Theta';
DCM.xY.modality  = 'LFP';
DCM.xY.Ic        = [1  2];  %% Channel 1 is hippocampus, channel 2 is the PFC
DCM.Sname        = {'HPC';'PFC'}; 
DCM.options.trials  = [1  3];    %%% Arranged 0, 4, 30, 8, 12 mg/kg Ketamine
DCM.options.analysis= 'CSD';    %  Select Spectral option
DCM.options.model   = 'CMM_NMDA';
DCM.options.spatial = 'LFP';
DCM.options.Tdcm    = [1 10000]; %% 10 sec trials
DCM.options.Fdcm    = [2 10]; %% gamma Frequency range to Fit
DCM.options.Nmodes  = 2;
DCM.options.subversion = 5;
DCM.options.D = 3;
%% Specify Connectivity 
DCM.A{1} = [0 0;0 0];    %% Forward 
DCM.A{2} = [0 1;1 0];    %% Backward  
DCM.A{3} = [0 0;0 0];    %% Both

%% Specify Modulations: Not Model 5 wins which has intrinsic gain effects in inhibitory interneurons
DCM.B{1} = [1 1;1 1];
 
%% Specify design Matrix
DCM.xU.X = [0 1]';  % Testing a parametric effect of Ketamine

%% Perform Inversion
DCM = spm_dcm_csd(DCM);
save(DCM.name,'DCM')

 
