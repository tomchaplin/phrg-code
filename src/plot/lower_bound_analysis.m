ep=0.001;
n = 5:5:200;
critical_p = zeros(size(n));

for i=1:length(n)
    critical_p(i) = fzero(@(p) the_bound(n(i),p,ep) - 0.05, [10^(-6),0.2]);
end
plot(n, critical_p)
xlabel('$n$','Interpreter','latex')
ylabel('$p_l^t(n)$','Interpreter','latex')

% Plot our theoretical bound against empirical
figure
MODE='nreg';
lower_betti1_plot
hold on
plot(n(4:30), critical_p(4:30))
legend({'Empirical $p=p_l(n)$',...
    sprintf('Best fit $p= %.3f \\,n^{%.3f}$', exp(intercept), slope),...
    'Theory $p=p_l^t(n)$'}, 'Interpreter','latex')
ylabel('$p$','Interpreter','latex')


% Probability bound that should work at small densities
function sum = the_bound(n, p, ep)
    sum = 0;
    err = ep*2;
    L=2;
    while err > ep && L<=n
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