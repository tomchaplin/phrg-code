addpath('../bounds')
n=10:10:3000;
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

ylim([0 1])
xlabel('$n$', 'Interpreter','latex')
ylabel('$p_c$', 'Interpreter','latex')
legend({'Theorem 4.17','Theorem 5.3'})
