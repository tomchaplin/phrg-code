addpath('../util')
results_merger
if strcmp(MODE,'nreg')
    nrl = length(n_range);
    test_results = test_results(1:nrl,:);
end
switch(MODE)
    case 'nreg'
        betti_str='\overrightarrow{\beta}_1(G)';
    case 'dflag'
        betti_str='\beta_1(\overrightarrow{X}(G))';
end
        
[rows, columns] = size(test_results);
means = cellfun(@(x) mean(x), test_results)';
prob_zero = cellfun(@(x) mean(x==0), test_results)';

figure
cth1 = plot_matrix(log(n_range), log(p_range), prob_zero, ...
    append('${\bf{P}}(',betti_str,'=0)$'));
caxis([0 1])

figure
[N, P] = meshgrid(n_range, p_range);
cth2 = plot_matrix(log(n_range), log(p_range), means./(N.*(N-1).*P),...
    append('$<',betti_str,'>/n(n-1)p$'));
%caxis([0 1])

function colorTitleHandle = plot_matrix(x, y, z, ctitle)
    [X, Y] = meshgrid(x,y);
    s=surf(X, Y, z);
    s.EdgeColor='none';
    view(0, 90);
    axis([min(x) max(x) min(y) max(y)])
    
    xlabel('$\log(n)$','Interpreter','latex')
    ylabel('$\log(p)$','Interpreter','latex')
    
    hcb = colorbar;
    colorTitleHandle = get(hcb,'Title');
    set(colorTitleHandle ,'String',ctitle,'Interpreter','latex');
end
