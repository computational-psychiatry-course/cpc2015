% create DCM for demo, very simple (2 regions).
modelNum=4;
for neuronal=1;
    
    DCM.a=ones(2,2);
    DCM.b=zeros(2,2,2);
    DCM.c=zeros(2,2);
    DCM.d=zeros(2,2,0);
    DCM.n=2;
    
    % define input U.
    if neuronal
        DCM.v=1000;
        DCM.Y.dt=0.1;
    else
        DCM.v=100;
        DCM.Y.dt=1;
    end
    
    DCM.Y.name={'Region 1','Region 2'};
    
    % define input
    DCM.U.dt=0.1;
    DCM.U.u=zeros(DCM.v*DCM.Y.dt/DCM.U.dt,2);
    indU1=repmat((1:5)',1,10)+repmat(100:100:1000,5,1);
    indU2=repmat((1:400)',1,4)+350;
%     DCM.U.u(indU1(:),1)=1;
%     DCM.U.u(indU2(:),2)=1;
    DCM.U.u(101:110)=1;
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
        case 1
            DCM.Ep.A=[0 0; 0 0];
            DCM.Ep.B(:,:,2)=[0 0; 0 0];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
        case 2
            DCM.Ep.A=[0 0; 0.3 0];
            DCM.Ep.B(:,:,2)=[0 0; 0 0];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
        case 3
            DCM.Ep.A=[0 0.3; 0.3 0];
            DCM.Ep.B(:,:,2)=[0 0; 0 0];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
        case 4
            DCM.Ep.A=[0 0; 0.3 0];
            DCM.Ep.B(:,:,2)=[0 0; -0.2 0];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
        case 5
            DCM.Ep.A=[0 0; 0.3 0];
            DCM.Ep.B(:,:,2)=[0 0; 0 -0.8];
            DCM.Ep.C=[0.3 0; 0 0];
            DCM.Ep.D=zeros(2,2,0);
    end
    
    DCM.Ep.transit=sparse(2,1);
    DCM.Ep.decay=sparse(2,1);
    DCM.Ep.epsilon=0;
    DCM.Cp=diag([0.04 0.156 0.156 0.4 zeros(1,4) 1 0 0 1 1 0 0 0 0.0025*ones(1,5)]);
    
    [Y,X]=spm_dcm_generate_jh(DCM,1000);
    if neuronal
        h=figure('DefaultAxesFontSize', 18, 'WindowStyle', 'default');
        subplot(7,1,2);
        plot((1:DCM.v)*DCM.Y.dt,X.x(:,1),'g','LineWidth',2);
        title('Neuronal activity');
        ylabel('a. u.');
       
        
        subplot(7,1,1);
        plot((1:length(DCM.U.u(:,1)))*DCM.U.dt,DCM.U.u(:,1),'r','LineWidth',2);hold on;
        title('Input u');
        ylabel('a. u.');
        axis([0 length(DCM.U.u(:,1))*DCM.U.dt 0 1.05]);
        box off;
        
                subplot(7,1,3);
        plot((1:DCM.v)*DCM.Y.dt,X.s(:,1),'LineWidth',2,'Color',[0.5 0 0]);
        title('Vasodilation s');
        ylabel('a. u.');
        box off;
        
                        subplot(7,1,4);
        plot((1:DCM.v)*DCM.Y.dt,X.f(:,1),'LineWidth',2,'Color',[0.5 0 0]);
        title('flow f');
        ylabel('a. u.');
        box off;
        
                                subplot(7,1,5);
        plot((1:DCM.v)*DCM.Y.dt,X.v(:,1),'LineWidth',2,'Color',[0.5 0 0]);
        title('volume v');
        ylabel('a. u.');
        box off;
        
                                        subplot(7,1,6);
        plot((1:DCM.v)*DCM.Y.dt,X.q(:,1),'LineWidth',2,'Color',[0.5 0 0]);
        title('deoxy-HB q');
        ylabel('a. u.');
        box off;
        
                                               subplot(7,1,7);
        plot((1:DCM.v)*DCM.Y.dt,Y.y(:,1),'LineWidth',2,'Color',[0.5 0 0]);
        title('BOLD signal');
        xlabel('time [s]');
        ylabel('a. u.');
        box off;
        
        for nSub=1:7
            subplot(7,1,nSub);
             xlim([0 50]);
        box off;
        end
        
    else
        figure(h);
        subplot(3,1,3);
        plot((1:DCM.v)*DCM.Y.dt,Y.y(:,1),'g','LineWidth',2);
        hold on;
        plot((1:DCM.v)*DCM.Y.dt,Y.y(:,2),'c','LineWidth',2);
        plot((1:DCM.v)*DCM.Y.dt,Y.yData(:,1),'g--');
        plot((1:DCM.v)*DCM.Y.dt,Y.yData(:,2),'c--');
        title('BOLD signal');
        ylabel('a. u.');
        box off;
        
    end
end
set(h,'Position',[100 100 400 1600]);

