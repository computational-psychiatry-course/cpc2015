function generate_prediction()
%% 
%
% Input
%
% Output
%
% aponteeduardo@gmail.com
% copyright (C) 2015
%

data = load('../dump/simulations/simulation.mat');
post = load('../dump/posteriors/posteriors.mat');
post = post.post;

ns = size(post.theta, 2);
nt = size(data.y, 1);

y = data.y;
u = data.u;

ptheta.vA0 = 2;
ptheta.vB0 = 2;

vA = zeros(nt, ns);
vB = zeros(nt, ns);
pA = zeros(nt, ns);

for i = 1:ns
    theta = post.theta(:, i);
    [tvA, tvB, tpA] = posterior_trace(y, u, theta, ptheta);
    vA(:, i) = tvA; 
    vB(:, i) = tvB; 
    pA(:, i) = tpA; 
end
vA = mean(vA, 2);
vB = mean(vB, 2);
pA = mean(pA, 2);

save('./../dump/simulations/posterior_traces.mat', 'vA', 'vB', 'pA');

end

