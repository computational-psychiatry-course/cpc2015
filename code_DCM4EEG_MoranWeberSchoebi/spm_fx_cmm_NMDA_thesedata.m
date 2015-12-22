function [f,J,Q] = spm_fx_cmm_NMDA(x,u,P,M)
% state equations for canonical neural-mass and mean-field models
% FORMAT [f,J,Q] = spm_fx_cmm(x,u,P,M)
%
% x - states and covariances
%
% x(i,j,k)        - k-th state of j-th population of i-th source
%                   i.e., running over sources, pop. and states
%
%   population: 
%               1 - superficial pyramidal cells     (forward output cells)
%               2 - inhibitory interneurons         (intrisic interneuons)
%               3 - deep pyramidal cells            (backward output cells)
%
%        state: 1 V  - voltage
%               2 gE - conductance (excitatory)
%               3 gI - conductance (inhibitory)
%
%--------------------------------------------------------------------------
% refs:
%
% Marreiros et al (2008) Population dynamics under the Laplace assumption
%
% See also:
%
% Friston KJ.
% The labile brain. I. Neuronal transients and nonlinear coupling. Philos
% Trans R Soc Lond B Biol Sci. 2000 Feb 29;355(1394):215-36. 
% 
% McCormick DA, Connors BW, Lighthall JW, Prince DA.
% Comparative electrophysiology of pyramidal and sparsely spiny stellate
% neurons of the neocortex. J Neurophysiol. 1985 Oct;54(4):782-806.
% 
% Brunel N, Wang XJ.
% What determines the frequency of fast network oscillations with irregular
% neural discharges? I. Synaptic dynamics and excitation-inhibition
% balance. J Neurophysiol. 2003 Jul;90(1):415-30.
% 
% Brunel N, Wang XJ.
% Effects of neuromodulation in a cortical network model of object working
% memory dominated by recurrent inhibition. J Comput Neurosci. 2001
% Jul-Aug;11(1):63-85.
%
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
 
% Karl Friston
% $Id: spm_fx_cmm.m 5082 2012-11-28 20:25:37Z karl $
 
%% ADJUSTED FOR KETAMINE RODENTS: NO STELLATES

% get dimensions and configure state variables
%--------------------------------------------------------------------------
ns   = size(M.x,1);                      % number of sources
np   = size(M.x,2);                      % number of populations per source
nk   = size(M.x,3);                      % number of states per population
x    = reshape(x,ns,np,nk);              % hidden states 


% extrinsic connection strengths
%==========================================================================
 
% exponential transform to ensure positivity constraints
%--------------------------------------------------------------------------
A{1}  = exp(P.A{1});                      % forward
A{2}  = exp(P.A{2});                      % backward
AN{1} = exp(P.AN{1});                      % forward
AN{2} = exp(P.AN{2});                      % backward
C     = exp(P.C);                         % subcortical
 

% detect and reduce the strength of reciprocal (lateral) connections
%--------------------------------------------------------------------------
for i = 1:length(A)
    L    = (A{i} > exp(-8)) & (A{i}' > exp(-8));
    A{i} = A{i}./(1 + 8*L);
end

% connectivity switches
%==========================================================================
% 1 - excitatory spiny stellate cells (granular input cells) %% ELIMINATE
% THESE FROM DYNAMICS
% 2 - superficial pyramidal cells     (forward  output cells)
% 3 - inhibitory interneurons         (intrisic interneuons)
% 4 - deep pyramidal cells            (backward output cells)

% extrinsic connections (F B) - from superficial and deep pyramidal cells
%--------------------------------------------------------------------------            
% intrinsic connection strengths
%==========================================================================

% condition specific effects: Inhibition of SPGP's
%--------------------------------------------------------------------------
G     = full(P.H);
GN    = full(P.HN);
  
   GN(2,1,:) = squeeze(GN(2,1,:)) + P.N;
   GN(3,1,:) = squeeze(GN(3,1,:)) + P.N;
 
%    if(M.subversion == 1 || M.subversion == 6)
%       G(3,2,:)  = squeeze(G(3,2,:))  + P.G;
%    elseif(M.subversion == 2 || M.subversion == 7)
%       G(1,2,:)  = squeeze(G(1,2,:))  + P.G;
%    elseif(M.subversion == 3 || M.subversion == 8)
%       G(2,2,:)  = squeeze(G(2,2,:))  + P.G;
%    elseif(M.subversion == 4 || M.subversion == 9)
%        G(1,1,:)  = squeeze(G(1,1,:))  + P.G;
%    elseif(M.subversion == 5 || M.subversion == 10)
       G(3,3,:)  = squeeze(G(3,3,:))  + P.G;
%    end
   
  GN    = exp(GN);
  G     = exp(G);
  GL   = 1*exp(P.GL);                   % leak conductance
  
  %if M.subversion < 6
      SA_to_PFC   =  [ 0   1 ;
                       0   0 ;
                       0   0]*16;
      
      
      SNMDA_to_PFC   = [0   1 ;
                        0   0 ;
                        0   0]*16;
      %%% To HPC
      
      SA_to_HPC   = [ 0   1 ;
                      0   0 ;
                      0   0]*16;
      
      
      SNMDA_to_HPC   = [0   1 ;
                        0   0 ;
                        0   0]*16;
%       
%   elseif M.subversion < 11
%       
%       SA_to_PFC   = [ 0   1 ;
%                       0   1 ;
%                       0   0]*16;
%       
%       
%       SNMDA_to_PFC   = [0   1 ;
%                         0   1 ;
%                         0   0]*16;
%       %%% To HPC
%       
%       SA_to_HPC   = [ 0   1 ;
%                       0   0 ;
%                       0   0]*16;
%       
%       
%       SNMDA_to_HPC   = [0   1 ;
%                         0   0 ;
%                         0   0]*16;
%   
  end

% intrinsic connections (np x np) - excitatory
%--------------------------------------------------------------------------
GE   = [  0    0    0
         64    0    0
         64    0    0];
     
 
% intrinsic connections (np x np) - inhibitory
%--------------------------------------------------------------------------
GI   = [ 32    32   0
         0     32    0
         0     32   32];
     
% rate constants (ns x np) (excitatory 4ms, inhibitory 16ms)
%--------------------------------------------------------------------------
KE    = exp(-P.T(:,1))*1000/4;              % excitatory rate constants (AMPA)
KI    = [1/16 1/8 1/8]*1000;                % inhibitory rate constants
KNMDA = 1000/100;                           % excitatory rate constants (NMDA)

% Voltages
%--------------------------------------------------------------------------
VL   = -70;                               % reversal  potential leak (K)
VE   =  60;                               % reversal  potential excite (Na)
VI   = -90;                               % reversal  potential inhib (Cl)
VR   = -40;                               % threshold potential
VN   =  10;                               % reversal Ca(NMDA)   

CV   = exp(P.CV).*[32 256 32]/1000;   % membrane capacitance

 
% mean-field effects:
%==========================================================================

% neural-mass approximation to covariance of states: trial specific
%----------------------------------------------------------------------
Vx   = exp(P.S)*32;

% mean population firing and afferent extrinsic input
%--------------------------------------------------------------------------
 
m       = spm_Ncdf_jdw(x(:,:,1),VR,Vx);    % mean firing rate  
a(:,1)  = A{1}*m(:,1);                     % forward afference
a(:,2)  = A{2}*m(:,3);                     % backward afference
an(:,1) = AN{1}*m(:,1);                   % forward afference
an(:,2) = AN{2}*m(:,3);                   % backward afference

% Averge background activity and exogenous input
%==========================================================================
BE     = exp(P.E);

% input
%--------------------------------------------------------------------------
if isfield(M,'u')
    
    % endogenous input
    %----------------------------------------------------------------------
    U = u(:);
    
else
    
    % exogenous input
    %----------------------------------------------------------------------
    U = C*u(:);
    
end

% flow over every (ns x np) subpopulation
%==========================================================================
f     = x;

for i = 1:ns
   
        % intrinsic coupling
        %------------------------------------------------------------------
        E      = (G(:,:,i).*GE)*m(i,:)';
        ENMDA  = (GN(:,:,i).*GE)*m(i,:)';
        I      = (G(:,:,i).*GI)*m(i,:)';
        
        
        % extrinsic coupling (excitatory only) and background activity
        %------------------------------------------------------------------
        if i ==1
            E     = (E     +  BE(i)   +  SA_to_HPC*a(i,:)');
            ENMDA = (ENMDA +  BE(i)   +  SNMDA_to_HPC*an(i,:)');
        elseif i == 2
             E     = (E     +  BE(i)  +  SA_to_PFC*a(i,:)');
             ENMDA = (ENMDA +  BE(i)  +  SNMDA_to_PFC*an(i,:)');
        end

        % and exogenous input(U)
        %------------------------------------------------------------------
        E(1)     = E(1)     + U(i);
        ENMDA(1) = ENMDA(1) + U(i);
        
        % Voltage
        %==================================================================
          f(i,:,1) =    (GL*(VL - x(i,:,1))+...
                         x(i,:,2).*(VE - x(i,:,1))+...
                         x(i,:,3).*(VI - x(i,:,1))+...
                         x(i,:,4).*(VN - x(i,:,1)).*mg_switch(x(i,:,1)))./CV;
        
        % Conductance
        %==================================================================
        f(i,:,2) = (E' - x(i,:,2)).*KE(i,:);
        f(i,:,3) = (I' - x(i,:,3)).*KI;
        f(i,:,4) = (ENMDA' - x(i,:,4)).*KNMDA ;
       
end

           
           
% vectorise equations of motion
%==========================================================================
f = spm_vec(f);
 
if nargout < 2, return, end

% Jacobian
%==========================================================================
J = spm_cat(spm_diff(M.f,x,u,P,M,1));

if nargout < 3, return, end

% Delays
%==========================================================================
% Delay differential equations can be integrated efficiently (but 
% approximately) by absorbing the delay operator into the Jacobian
%
%    dx(t)/dt     = f(x(t - d))
%                 = Q(d)f(x(t))
%
%    J(d)         = Q(d)df/dx
%--------------------------------------------------------------------------
% [specified] fixed parameters
%--------------------------------------------------------------------------
D  = [2 16];

d  = -D.*exp(P.D)/1000;
Sp = kron(ones(nk,nk),kron( eye(np,np),eye(ns,ns)));  % states: same pop.
Ss = kron(ones(nk,nk),kron(ones(np,np),eye(ns,ns)));  % states: same source

Dp = ~Ss;                            % states: different sources
Ds = ~Sp & Ss;                       % states: same source different pop.
D  = d(2)*Dp + d(1)*Ds;


% Implement: dx(t)/dt = f(x(t - d)) = inv(1 - D.*dfdx)*f(x(t))
%                     = Q*f = Q*J*x(t)
%--------------------------------------------------------------------------
Q  = spm_inv(speye(length(J)) - D.*J);


