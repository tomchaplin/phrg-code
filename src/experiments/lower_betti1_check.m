addpath('../util')
addpath('../../lib/pathhomology')
rng(42);

n_range = 20:5:150;
p_range = logspace(log10(0.0001), log10(0.15));
tests = 100;

test_results = persForLoopSplitSaves(n_range, p_range,...
    @(n,p) the_experiment(n,p,tests), 'lower_betti1');
save('../../mat/lower_betti1_check')

function output = the_experiment(n, p, tests)
    output = zeros(tests, 1);
    for i=1:tests
        G = createDERG(n, p);
        ph = pathhomology(G, 2);
        output(i) = ph.betti(2);
    end
end

function G = createDERG(n, p)
	% Random durected graph
	A = rand(n,n) <= p;
	% Remove any self loops
	A = A .* (1-eye(n));
	G = digraph(A);
end
