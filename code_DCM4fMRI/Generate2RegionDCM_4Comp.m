% create DCM for demo, very simple (2 regions).
% addpath(genpath('E:\Documents\software\Matlab\Toolboxes\Tapas\HGF'));
% Define your model, learning and modulation type

% Agenda:
% 1) Simulate/Generate Input Data u
% 2) Specify DCMs, in particular connectivity:
%    A (intrinsic), B (modulatory), C (direct input)
% 3) Simulate DCM region time courses
% 4) Plot Neuronal or BOLD Signal

modelNum=3;
modulation='PE';
plotPE=true;
sizeLearningStages =2;

% neuronal 1     = simualate for output of neuronal states (finer time steps)
% neuronal 0     = simualate for output of BOLD states (coarser time steps)
for neuronal=1:-1:0;
    
    DCM.a=ones(2,2);
    DCM.b=zeros(2,2,2);
    DCM.c=zeros(2,2);
    DCM.d=zeros(2,2,0);
    DCM.n=2;
    
    % define input U.
    if neuronal
        DCM.v=5300;
        DCM.Y.dt=0.1;
    else
        DCM.v=530;
        DCM.Y.dt=1;
    end
    
    DCM.Y.name={'TPJ','dmPFC'};
    
    % define input
    DCM.U.dt=0.1;
    DCM.U.u=zeros(DCM.v*DCM.Y.dt/DCM.U.dt,2);
    
    
    %% 1) Simulate/Generate Input Data u
    
    nStimulus = 50*sizeLearningStages;
    durationStimulus = 10; % Duration in seconds
    spacingStimulus = 100;  %
    indU1=repmat((1:durationStimulus)',1,nStimulus)+...
        repmat(100+(0:nStimulus-1)*spacingStimulus,durationStimulus,1); % When the stimulus occurs
    DCM.U.u(indU1(:),1)=2;
    
    switch modulation
        case 'simple'
            indU2=repmat((1:400)',1,4)+350;
            DCM.U.u(indU2(:),2)=1;
            
        case 'PE'
            meanProb=[tapas_logit(0.9,1) tapas_logit(0.1,1)...
                tapas_logit(0.9,1)];
            %             meanProb=[tapas_logit(0.6,1) tapas_logit(0.5,1)...
            %                       tapas_logit(0.9,1)];
            u = [];
            
            for iStages=1:sizeLearningStages
                inputVector=gen_design(meanProb(iStages), nStimulus/sizeLearningStages - 1);
                u=[u;inputVector];
            end
            
            sim = tapas_simModel(u, 'tapas_hgf_binary', [NaN 0 1 NaN 1 1 NaN 0 0 NaN 1 NaN -2.5 -6], 'tapas_unitsq_sgm', 5);
            if plotPE==true
                figure; plot(abs(sim.traj.epsi(:,2)))
            end
            indU2 = indU1;
            parametricModulator = repmat(abs(sim.traj.epsi(:,2))', durationStimulus, 1); % Presentation and Duration
            parametricModulator = reshape(parametricModulator, [], 1);
            DCM.U.u(indU2,2) = parametricModulator;
    end
    
    %% 2) Specify DCMs, in particular connectivity:
    %     A (intrinsic), B (modulatory), C (direct input)
    
    
    %DCM.U.u(101:105)=1;
    DCM.U.name={'Driving','Modulating'};
    DCM.delays=DCM.Y.dt/2*ones(2,1);
    DCM.TE=0.04;
    
    
    DCM.options.nonlinear = 0;
    DCM.options.two_state = 0;
    DCM.options.stochastic = 0;
    DCM.options.centre = 0;
    DCM.options.endogenous = 0;
    DCM.options.nmax = 8;
    DCM.options.nN = 32;
    DCM.options.hidden = [];
    DCM.options.induced = 0;
    
    DCM.M.delays=DCM.delays;
    DCM.M.TE=DCM.TE;
    DCM.M.IS='spm_int';
    DCM.M.f='spm_fx_fmri';
    DCM.M.g='spm_gx_fmri';
    DCM.M.x=sparse(2,5);
    
    %define connections
    
    DCM.M.m=2;
    DCM.M.n=10;
    DCM.M.l=2;
    DCM.M.N=32;
    DCM.M.dt=0.5;
    DCM.M.ns=DCM.v;
    switch modelNum %get the right parameters for each demo, neuronal parameters only
        case 1 % No Modulation
            DCM.Ep.A=[0 0; 0.6 0];
            DCM.Ep.B(:,:,2)=[0 0; 0 0];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
        case 2 % Self Inhibition
            DCM.Ep.A=[0 0; 0.6 0];
            DCM.Ep.B(:,:,2)=[0 0; 0 -0.7];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
        case 3 % Forward Modulation
            DCM.Ep.A=[0 0; 0.3 0];
            DCM.Ep.B(:,:,2)=[0 0; 0.6 0];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
    end
    
    DCM.Ep.transit=sparse(2,1);
    DCM.Ep.decay=sparse(2,1);
    DCM.Ep.epsilon=0; %0
    DCM.Cp=diag([0.04 0.156 0.156 0.4 zeros(1,4) 1 0 0 1 1 0 0 0 0.0025*ones(1,5)]);
    
    
    %% 3) Simulate DCM region time courses
    
    % neuronal data X, BOLD data Y
    [Y,X]=spm_dcm_generate_jh(DCM,1);
    
    
    %% 4) Plot Neuronal or BOLD Signal
    
    h=figure('DefaultAxesFontSize', 24, 'WindowStyle', 'docked');
    
    subplot(3,1,1);
    plot((1:length(DCM.U.u(:,1)))*DCM.U.dt,DCM.U.u(:,1),'r','LineWidth',2);hold on;
    plot((1:length(DCM.U.u(:,1)))*DCM.U.dt,DCM.U.u(:,2),'m','LineWidth',2);
    title('Inputs u');
    
    set(gca,'YTick',[],'XTick',[],'FontSize',16);
    axis([0 length(DCM.U.u(:,1))*DCM.U.dt 0 max(DCM.U.u(:))]);
    box off;
    
    subplot(3,1,2:3);
    if neuronal
        
        
        plot((1:DCM.v)*DCM.Y.dt,X.x(:,1),'g','LineWidth',2);
        hold on;
        plot((1:DCM.v)*DCM.Y.dt,X.x(:,2),'b','LineWidth',2);
        title('Neuronal activity');
        axis([0 DCM.v*DCM.Y.dt min(X.x(:)) max(X.x(:))]);
        set(gca,'YTick',[],'FontSize',16);
        xlabel('time [s]','FontSize',24);
        box off;
        
        
    else
        
        plot((1:DCM.v)*DCM.Y.dt,Y.yData(:,1),'g','LineWidth',2);
        hold on;
        plot((1:DCM.v)*DCM.Y.dt,Y.yData(:,2),'b','LineWidth',2);
        title('BOLD signal');
        axis([0 DCM.v*DCM.Y.dt min(Y.yData(:))-0.01 max(Y.yData(:))+0.01]);
        set(gca,'YTick',[],'FontSize',16);
        xlabel('time [s]','FontSize',24);
        box off;
        
    end
end

