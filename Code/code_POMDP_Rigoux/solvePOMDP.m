function results = solvePOMDP(filename)


%% ========================================================================
%  SOLVING THE POMDP
%  ========================================================================

%% ------------------------------------------------------------------------
%   Calling the pomdp-solve routine
%% ------------------------------------------------------------------------

fprintf('Solving the pomdp...');

% call the solver
[status,cmdout] = system(sprintf(' ./pomdp-solve -pomdp %s.POMDP -o ''%s-solution''',filename,filename));

% load the results
pomdp = readPOMDP([filename '.POMDP']) ;

fprintf('done\n');


%% ------------------------------------------------------------------------
%   Loading the alpha vectors
%% ------------------------------------------------------------------------

fid = fopen([filename '-solution.alpha']);
% => see http://pomdp.org/code/alpha-file-spec.html

A = fscanf(fid,'%d%f%f') ;
A = reshape(A,3,numel(A)/3);

fclose(fid) ;

alpha_action = A(1,:);
alpha_vector = A(2:3,:);

%% ------------------------------------------------------------------------
%   Computing the value function
%% ------------------------------------------------------------------------

% for display purpose, we will evaluate the value of each action over the
% full continuous belief space

belief_subsampling = 100;
belief_space = linspace(0,1,belief_subsampling); % 0: tiger-left, 1:tiger-right

% compute value function for each alpha vector
for i=1:belief_subsampling
    V_alpha(:,i) = [1-belief_space(i)  belief_space(i)] * alpha_vector ;
end

% collapse vectors associated with the same same action
for iAction = 1:pomdp.nrActions
    act_idx = find(alpha_action == (iAction-1));
    V(iAction,:) = max(V_alpha(act_idx,:),[],1);
end
% => V is the value of each action (lines) as a function of belief (columns)

%% ------------------------------------------------------------------------
%   Loading the belief MDP policy
%% ------------------------------------------------------------------------

fid = fopen([filename '-solution.pg']);
% => see http://pomdp.org/code/pg-file-spec.html

P = fscanf(fid,'%d') ;
P = reshape(P,2+pomdp.nrObservations,numel(P)/(2+pomdp.nrObservations));

bmdp.nrStates = size(P,2);

for iS = 1:bmdp.nrStates
    for iO = 1:pomdp.nrObservations
        bmdp.transition(P(2+iO,iS)+1,iS,iO)=1;
    end
end

bmdp.policy = P(2,:)+1;

policy_belief = zeros(size(V_alpha,1),belief_subsampling);
for i=1:belief_subsampling
    bestS = find(V_alpha(:,i) == max(V_alpha(:,i)),1) ;
    policy_belief(bestS,i) = bmdp.policy(bestS);
end
% => S is the optimal policy for each substate as a function of belief (columns)

%% ========================================================================
%  PROFILING OPTIMAL BEHAVIOUR
%  ========================================================================

%% ------------------------------------------------------------------------
%   Simulation of the POMDP under the optimal policy
%% ------------------------------------------------------------------------

fprintf('Simulating...');

%initial state is neutral belief
state_mdp = 1 ;
% random belief
state_bel = randi(bmdp.nrStates) ;

N = 1e4;
for iT = 1:N
    
    % choose action according to beliefs
    action = bmdp.policy(state_bel) ;
    
    % update real world accordingly
    next_state_mdp_distrib = pomdp.transition(:,state_mdp,action) ;
    next_state_mdp = find(cumsum(next_state_mdp_distrib) > rand,1) ;
    
    % find corresponding observation
    observation_distrib = pomdp.observation(next_state_mdp,action,:) ;
    observation = find(cumsum(observation_distrib) > rand,1) ;
    
    % compute belief update
    next_state_bel_distrib = bmdp.transition(:,state_bel,observation) ;
    next_state_bel = find(cumsum(next_state_bel_distrib) > rand,1) ;
    
    % store
    simulation.state(iT)  = state_mdp;
    simulation.belief(iT) = state_bel;
    simulation.action(iT) = action;
    simulation.observation(iT) = observation;
    
    % update
    state_mdp = next_state_mdp ;
    state_bel = next_state_bel ;
    
end
fprintf('done\n');



%% ========================================================================
%  SAVING EVERYTHING
%  ========================================================================

results.log.date           = datetime ;
results.log.config_file    = [filename '.POMDP'] ;
results.log.optimization   = cmdout ;

results.pomdp  = pomdp ;
results.bmdp   = bmdp ;
results.simul  = simulation ;

results.plot.belief_space  = belief_space ;
results.plot.alpha_values  = V_alpha ;
results.plot.policy_belief = policy_belief;
results.plot.action_values = V ;

save(filename, 'results');



end



