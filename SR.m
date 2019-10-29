function mod = SR(params, trainmat)
    mod = struct();
    
    %parsing of params
    ls = params.ls;
    lr = params.lr;
    p = params.p;
    s = params.s; %shape
    space_min = params.space_min;
    space_max = params.space_max;
    space_resolution = params.space_resolution;

    %initialize strspace
    ndims = size(trainmat, 2)-1;
    seq = space_min:(space_max/(space_resolution-1)):space_max;
    space = eval(['combvec(' repmat('seq,', [1, ndims-1]) 'seq)'])';
    strs = zeros(size(space, 1), 2);
    
    %train
    for t = 1:size(trainmat, 1)
        stim1 = trainmat(t, 1:ndims, 1);
        stim2 = trainmat(t, 1:ndims, 2);
        %get similarities
        sim1 = getSim(stim1, space, s, p);
        sim2 = getSim(stim2, space, s, p);
        %update
        if trainmat(t, ndims+1, 1)
            strs = deltaStr(strs, [sim1, sim2], ls, lr);
        else
            strs = deltaStr(strs, [sim2, sim1], ls, lr);
        end        
    end
    mod.trainmat = trainmat;
    mod.space = space;
    mod.strs = strs;
    mod.params = params;
    
    
function strs = deltaStr(strs, sims, ls, lr)
    strs(:, 1) = strs(:, 1) + ls.*sims(:, 1);
    strs(:, 2) = strs(:, 2) + lr.*sims(:, 2);
    
function sims = getSim(e, x, s, p)
    sims = exp(-s.*mDist(e, x, p));

function dists = mDist(e, x, p)
    dists = sum(abs(x-e).^p, 2).^(1/p);
    
    
    
    
    
    
    