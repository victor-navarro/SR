%close all
%clear all
cd 'C:/Users/vnavarro/OneDrive - University of Iowa/Wasserman''s Lab/Experiments/2019 CatRejectControl/sims'
params = struct;
params.ls = .001;
params.lr = .01;
params.p = 1;
params.s = 5;
params.space_min = -1;
params.space_max = 1;
params.space_resolution = 50;

nstims = 1000;
%% random task %%
t = [];
t = [-1 + (1-(-1)).*rand(nstims, 2), randi(2, nstims, 1)-1];
t(:, :, 2) = [-1 + (1-(-1)).*rand(nstims, 2), ~t(:, 3)];

%% RB task %%
stims = -1 + (1-(-1)).*rand(nstims*10, 2);
stims(:, 3) = stims(:, 1) < 0;
as = stims(stims(:, 3) == 1, :);
bs = stims(stims(:, 3) == 0, :);
t = [];
t(:, :, 1) = as(randi(size(as, 1), [1, nstims]), :);
t(:, :, 2) = bs(randi(size(bs, 1), [1, nstims]), :);

%% II task %%
stims = -1 + (1-(-1)).*rand(nstims*10, 2);
stims(:, 3) = stims(:, 1) < 0;
a = .25*pi; %set rotation (in radians)
rmat = [cos(a), -sin(a); sin(a), cos(a)];
stims(:, 1:2) = stims(:, 1:2)*rmat;
as = stims(stims(:, 3) == 1, :);
bs = stims(stims(:, 3) == 0, :);
t = [];
t(:, :, 1) = as(randi(size(as, 1), [1, nstims]), :);
t(:, :, 2) = bs(randi(size(bs, 1), [1, nstims]), :);

%% XOR task %%
stims = -1 + (1-(-1)).*rand(nstims*10, 2);
stims(:, 3) = xor(ceil(stims(:, 1)), ceil(stims(:, 2)));
as = stims(stims(:, 3) == 1, :);
bs = stims(stims(:, 3) == 0, :);
t = [];
t(:, :, 1) = as(randi(size(as, 1), [1, nstims]), :);
t(:, :, 2) = bs(randi(size(bs, 1), [1, nstims]), :);

%% rotated XOR task %%
stims = -1 + (1-(-1)).*rand(nstims*10, 2);
stims(:, 3) = xor(ceil(stims(:, 1)), ceil(stims(:, 2)));
a = .25*pi; %set rotation (in radians)
rmat = [cos(a), -sin(a); sin(a), cos(a)];
stims(:, 1:2) = stims(:, 1:2)*rmat;
as = stims(stims(:, 3) == 1, :);
bs = stims(stims(:, 3) == 0, :);
t = [];
t(:, :, 1) = as(randi(size(as, 1), [1, nstims]), :);
t(:, :, 2) = bs(randi(size(bs, 1), [1, nstims]), :);

%% DONUT task %%
stims = -1 + (1-(-1)).*rand(nstims*10, 2);
radius = .5;
stims(:, 3) = stims(:, 1).^2+stims(:, 2).^2 < radius^2;
as = stims(stims(:, 3) == 1, :);
bs = stims(stims(:, 3) == 0, :);
t = [];
t(:, :, 1) = as(randi(size(as, 1), [1, nstims]), :);
t(:, :, 2) = bs(randi(size(bs, 1), [1, nstims]), :);

%% Split DONUT task
stims = -1 + (1-(-1)).*rand(nstims*10, 2);
radius = .5;
stims(:, 3) = stims(:, 1).^2+stims(:, 2).^2 < radius^2;
stims(stims(:, 1) > 0, 3) = ~stims(stims(:, 1) > 0, 3);
as = stims(stims(:, 3) == 1, :);
bs = stims(stims(:, 3) == 0, :);
t = [];
t(:, :, 1) = as(randi(size(as, 1), [1, nstims]), :);
t(:, :, 2) = bs(randi(size(bs, 1), [1, nstims]), :);

%% Select-Reject categorization %%
stims = -1 + (1-(-1)).*rand(nstims*10, 2);
stims(:, 3) = ~xor(ceil(stims(:, 1)), ceil(stims(:, 2)));
as = stims(stims(:, 3) & stims(:, 1) < 0, :);
bs = stims(stims(:, 3) & stims(:, 1) > 0, :);
bs(:, 3) = ~bs(:, 3);
cs = stims(~stims(:, 3), :);
t(:, :, 1) = [as(randi(size(as, 1), [1, nstims/2]), :); cs(randi(size(cs, 1), [1, nstims/2]), :)];
cs(:, 3) = ~cs(:, 3);
t(:, :, 2) = [bs(randi(size(bs, 1), [1, nstims/2]), :); cs(randi(size(cs, 1), [1, nstims/2]), :)];

%% Same but normal distributions %%
%set means
ms = [-.5, .5;
      .5, .5;
      .5, -.5;
      -.5, -.5];

%set covariance matrix  
variance = .04;
sigma = [variance, 0; 0, variance];

%set the number of standard deviations for cutoff
ndevs = 3;

%set the number of stimuli to be generated
nstim = 1000;

stims = [];
for d = 1:4
    dist = mvnrnd(ms(d, :), sigma, nstim);
    %eliminate overly aberrant stimuli
    stds = [ms(d, 1)-sqrt(sigma(1, 1))*ndevs, ms(d, 1)+sqrt(sigma(1, 1))*ndevs,  ms(d, 2)-sqrt(sigma(2, 2))*ndevs, ms(d, 2)+sqrt(sigma(2, 2))*ndevs];
    dist = dist(dist(:, 1) > stds(1) & dist(:, 1) < stds(2) & dist(:, 2) > stds(3) & dist(:, 2) < stds(4), :);
    %elminate stimuli that go outside the range
    dist = dist(abs(dist(:, 1)) < 1 & abs(dist(:, 2)) < 1, :);
    stims = [stims; dist, ones(length(dist), 1)*d];
end

stims(:, 3) = ~xor(ceil(stims(:, 1)), ceil(stims(:, 2)));
as = stims(stims(:, 3) & stims(:, 1) < 0, :);
bs = stims(stims(:, 3) & stims(:, 1) > 0, :);
bs(:, 3) = ~bs(:, 3);
cs = stims(~stims(:, 3), :);
t(:, :, 1) = [as(randi(size(as, 1), [1, nstims/2]), :); cs(randi(size(cs, 1), [1, nstims/2]), :)];
cs(:, 3) = ~cs(:, 3);
t(:, :, 2) = [bs(randi(size(bs, 1), [1, nstims/2]), :); cs(randi(size(cs, 1), [1, nstims/2]), :)];
%% Model

m = SR(params, t);
plotCategorySpace(m);
plotControl(m);
