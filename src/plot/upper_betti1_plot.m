switch(MODE)
    case 'nreg'
        load('../../mat/upper_betti1_check')
    case 'dflag'
        load('../../mat/upper_betti1_dflag_check')
end
conf = 0.05;
mostly_zero = cellfun(@(x) mean(x>0) <= conf, test_results);

pu = [];

for i=1:length(n_range)
    this_row = mostly_zero(i,:);
    zero_indices = find(this_row == 0);
    last_zero_idx = zero_indices(end);
    first_all_one_idx = last_zero_idx + 1;
    p = p_range(first_all_one_idx);
    pu = [pu p];
end

% Linear regression
Y = log(pu');
X = [ones(length(n_range), 1), log(n_range)'];
B = X \ Y;
intercept = B(1);
slope = B(2);

% Plotting
%figure
scatter(n_range, pu, 'x');
hold on
plot(exp(X(:,2)), exp(X*B));
set(gca,'xscale','log');
set(gca,'yscale','log');
legend({'Empirical $p=p_u(n)$',...
    sprintf('$$p = %.3f \\,n^{%.3f}$$', exp(intercept), slope)},...
    'Interpreter','latex')
xlabel('$n$','Interpreter','latex')
ylabel('$p$','Interpreter','latex')

if strcmp(MODE,'dflag')
    xticks(50:50:200)
end
