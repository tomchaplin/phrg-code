n = 10000:10000:15000000;
bd = zeros(size(n));

p = logspace(log10(10^(-7)), log10(10^(-1)));

[N, P] = meshgrid(n, p);
bd = zeros(size(N));
[rows, cols] = size(bd);

for i = 1:rows
    for j=1:cols
        bd(i,j) = the_bound(N(i,j), P(i,j));
    end
    disp(i)
end
% 
% s=surf(N,P,bd);
% axis([min(n), max(n), min(p), max(p)])
% view([0 90])
% colorbar
% s.EdgeColor='none';
% set(gca,'xscale','log')
% set(gca,'yscale','log')

min_prob = zeros(size(n));
for i = 1:length(n)
    [~, fval] = fminbnd(@(p) the_bound(n(i),10^p), -8,-2);
    min_prob(i) = fval;
end
plot(n, min_prob);
xlabel('$n$','Interpreter','latex')
ylabel('$\min \bf{P}$','Interpreter','latex')
hold on
plot([min(n) max(n)], [0.05 0.05], '--')
plot([min(n) max(n)], [0.1 0.1], '--')
set(gca,'xscale','log')
set(gca,'yscale','log')

% Probability bound that should work at small densities
function bd = the_bound(n, p)
    num = numerator(n, p);
    denom = denominator(n, p);
    bd = 1-(num/denom);
end

function num = numerator(n, p)
    en2 = n*((n-1)^2)*(p^2) - n*(n-1)*(1-p)*(1-((1-p^2)^(n-2)))-n*(1-((1-p^2)^(n-1)));
    en1 = n*(n-1)*p;
    num = max(0, -n + en1 - en2);
    num = num*num;
end

function den =denominator(n, p)
    den = n*(n-1)*p*(1-p) + (n^2)*((n-1)^2)*(p^2);
end