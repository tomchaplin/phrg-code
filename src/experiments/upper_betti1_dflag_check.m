addpath('../util')
rng(42);

n_range = 20:5:200;
p_range = logspace(log10(0.1), log10(0.45));
tests = 200;
WORKERS = 16;
pool = parpool(WORKERS);
maxNumCompThreads(WORKERS);

test_results = persForLoopSplitSaves(n_range, p_range,...
    @(n,p) the_experiment(n,p,tests,pool), 'upper_betti1_dflag');
save('../../mat/upper_betti1_dflag_check')

function output = the_experiment(n, p, tests, pool)
    % Initialise an array of futures
    f(1:tests) = parallel.FevalFuture;
    % Populate futures with single_tests
    for i=1:tests
        f(i) = parfeval(pool, @() single_test(n,p), 1);
    end
    % Wait for futures and collect results into a (tests x 1) double
    output = fetchOutputs(f);
end

function b1 = single_test(n,p)
    A = createDERG(n,p);
    bettis = flagser_hom(A, 1, '../../lib/flagser/flagser');
    b1 = bettis(2);
end

function A = createDERG(n, p)
	% Random durected graph
	A = rand(n,n) <= p;
	% Remove any self loops
	A = A .* (1-eye(n));
end
