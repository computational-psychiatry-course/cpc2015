%%------------- BPA
clear all
load 'DCM_ServerCMM_NMDA_Theta_5subversion_d_two_trial_5'
DCM_Theta = DCM;
load 'DCM_ServerCMM_NMDA_Gamma_5subversion_d_all_5'
DCM_Gamma = DCM;

indices = [30 31 32 33 34 35 36 37]; %% THE  B PARAMETERS [intrinsic_HPC (30); HPC_to_PFC (31); PFC_TO_HPC (32); intrinsic_PFC (33); intrinsic_NMDA_HPC (34); HPC_to_PFC_NMDA (35); PFC_TO_HPC_NMDA (36); intrinsic_NMDA_PFC(37); ]
Ep_Theta = full(spm_vec(DCM_Theta.Ep));
Ep_Gamma = full(spm_vec(DCM_Gamma.Ep));

for i = 1:length(indices)
    
    mean_theta(i)   = Ep_Theta(indices(i))
    mean_gamma(i)   = Ep_Gamma(indices(i))
    
    prec_theta(i)    =  1/DCM_Theta.Cp(indices(i),indices(i));
    prec_gamma(i)    =  1/DCM_Gamma.Cp(indices(i),indices(i));
    total_prec       =  prec_theta(i) + prec_gamma(i);
    Ep_combo(i)      =  (mean_theta(i)*prec_theta(i) + mean_gamma(i)*prec_gamma(i))/total_prec;
    Cp_combo(i)      =  1/(prec_theta(i) + prec_gamma(i));
    Pp_combo(i)      =  1 - spm_Ncdf(0,abs(Ep_combo(i)),Cp_combo(i))
    
end



%%% Individual Theta
indices = [30 31 32 33 34 35 36 37]; %% THE  B PARAMETERS [intrinsic_HPC (30); HPC_to_PFC (31); PFC_TO_HPC (32); intrinsic_PFC (33); intrinsic_NMDA_HPC (34); HPC_to_PFC_NMDA (35); PFC_TO_HPC_NMDA (36); intrinsic_NMDA_PFC(37); ]
Ep_Theta = full(spm_vec(DCM_Theta.Ep));

for i = 1:length(indices)   
    mean_theta(i)    =  Ep_Theta(indices(i));
    var_theta(i)     =  DCM_Theta.Cp(indices(i),indices(i));   
    Pp_theta(i)      =  1 - spm_Ncdf(0,abs(mean_theta(i)),var_theta(i))
end


%%% Individual Gamma
indices = [30 31 32 33 34 35 36 37]; %% THE  B PARAMETERS [intrinsic_HPC (30); HPC_to_PFC (31); PFC_TO_HPC (32); intrinsic_PFC (33); intrinsic_NMDA_HPC (34); HPC_to_PFC_NMDA (35); PFC_TO_HPC_NMDA (36); intrinsic_NMDA_PFC(37); ]
Ep_Gamma = full(spm_vec(DCM_Gamma.Ep));

for i = 1:length(indices)
    mean_gamma(i)    =  Ep_Gamma(indices(i));
    var_gamma(i)     =  DCM_Gamma.Cp(indices(i),indices(i));   
    Pp_gamma(i)      =  1 - spm_Ncdf(0,abs(mean_gamma(i)),var_gamma(i))
end


