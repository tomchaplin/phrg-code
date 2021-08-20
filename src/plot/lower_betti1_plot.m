switch(MODE)
    case 'nreg'
        load('../../mat/lower_betti1_check')
    case 'dflag'
        load('../../mat/lower_betti1_dflag_check')
end
conf = 0.05;
mostly_zero = cellfun(@(x) mean(x>0) <= conf, test_results);

pl = [];

for i=1:length(n_range)
    this_row = mostly_zero(i,:);
    zero_indices = find(this_row == 0);
    first_zero_idx = zero_indices(1);
    last_all_one_idx = first_zero_idx - 1;
    p = p_range(last_all_one_idx);
    pl = [pl p];
end

% Transform pl to \bar{pl}

%plbar = (1 - (1-pl).^2)';
plbar = pl';
x = n_range';

% Linear regression
Y = log(plbar);
X = [ones(length(n_range), 1), log(x)];
B = X \ Y;
intercept = B(1);
slope = B(2);



% Plotting
%figure
scatter(x, plbar, 'x');
hold on
plot(exp(X(:,2)), exp(X*B));
set(gca,'xscale','log');
set(gca,'yscale','log');
%the_title = sprintf('$$\\alpha=%.2f,\\; slope=%f,\\; intercept=%f$$',...
%    conf, slope, intercept);
%title(the_title, 'interpreter','latex');
legend({'Empirical $p=p_l(n)$',...
    sprintf('$$p = %.3f \\,n^{%.3f}$$', exp(intercept), slope)},...
    'Interpreter','latex')
xlabel('$n$','Interpreter','latex')
ylabel('$p(n)$','Interpreter','latex')

if strcmp(MODE,'dflag')
    xticks(50:50:200)
end
