addpath('../bounds')
n=10:10:1000;
large_p = zeros(1, length(n));
practical_p = zeros(1, length(n));
ep = 0.05;
tiny = 0.1;

for i=1:length(n)
    large_p(i) = fzero(@(x) large_p_bound(n(i), x) - ep, [tiny, 1]);
    practical_p(i) = fzero(...
      @(x) practical_bound(n(i),x,'../../mat/computed_Q.mat') - ep, [tiny 1]);
end

plot(n, large_p);
hold on
plot(n, practical_p);
set(gca,'xscale','log');
set(gca,'yscale','log');

ylim([0 1])
xlabel('$n$', 'Interpreter','latex')
ylabel('$p_u^t(n)$', 'Interpreter','latex')
legend({'Theorem 4.16','Theorem A.7'})

function out = large_p_bound(n,p)
    out = nchoosek(n, 4)*factorial(4)*8*p^3*(1-p^3)^(n-4);
    out = out + nchoosek(n, 2)*p^2*(1-p^2)^(n-2);
    out = out + 2*nchoosek(n, 3)*(p^3)*(1-p^3)^(n-3);
end

function bound = practical_bound(n, p, Q_file)
    load(Q_file,'Q');
    C = [2 4 4 4];
    bound = 0;
    bound = bound + probBad3Path(n,p,Q,C);
    bound = bound + probBad3Cycle(n, p);
    bound = bound + probBad2Cycle(n, p);
end

function bound = probBad3Path(n, p, Q, C)
    bound = 0;
    for m=0:3
        prob_Ask = 0;
        for l=0:8
            prob_Ask = prob_Ask + Q(m+1,l+1)*p^l*(1-p)^(8-l);
        end
        bound = bound + p^3*(1-p)^(C(m+1))*(1- prob_Ask)^(n-4);
    end
    bound = nchoosek(n, 4) * factorial(4) * bound;
end

function bound = probBad3Cycle(n, p)
    bound = 2 * nchoosek(n, 3) * p^3 * (1-p^3)^(2*n-6);
end

function bound = probBad2Cycle(n, p)
    bound = nchoosek(n, 2) * p^2 * (1-p^2)^(2*n-4);
end
