ep = 0.1;
max_L = 1000;
n = 5:5:200;
critical_p = zeros(size(n));

for i=1:length(n)
    critical_p(i) = fzero(@(p) the_bound(n(i),p,ep,max_L) - 0.05, [10^(-6),0.2]);
end
plot(n, critical_p)
xlabel('$n$','Interpreter','latex')
ylabel('$p_c(n)$','Interpreter','latex')

% Probability bound that should work at small densities
function sum = the_bound(n, p, ep, max_L)
    sum = 0;
    err = ep*2;
    L=2;
    while err > ep && L<=max_L && L<=n
        % Save
        old_sum = sum;
        % Compute next
        next_term = nchoosek(n,L) * factorial(L)/(2*L)*(2*p)^L;
        sum = old_sum + next_term;
        % Compute err
        err = abs(sum - old_sum);
        % Prepare for next loopse
        L = L+1;
    end
    if sum < 0
        sum = 0;
    end
    if sum > 1
        sum = 1;
    end
end