%% Setup
summary_method = 'average';
switch(MODE)
    case 'nreg'
        load('../../mat/lower_betti1_check')
    case 'dflag'
        load('../../mat/lower_betti1_dflag_check')
end
[rows, columns] = size(test_results);
num_tests = 10;
pr = zeros(rows, columns, num_tests);
titles = {'KS Limiting Form',...
    'KS Stephens Modification',...
    'KS Marsaglia Method',...
    'KS Lilliefors Modification',...
    'Anderson-Darling Test',...
    'Cramer- Von Mises Test',...
    'Shapiro-Wilk Test',...
    'Shapiro-Francia Test',...
    'Jarque-Bera Test',...
    'DAgostino & Pearson Test'};
NO_TEST = -1/256;
NO_TEST_COLOR = [0.7 0 0];
conf = 0.05;

%% Fit testing
for i=1:rows
    for j=1:columns
        % Only conduct test where emprically we see
        % Betti numbers are probably positive (i.e. probably not 0)
        % i.e. EmpiricalProb(betti_1 == 0) <= 0.05
        if mean(test_results{i,j} == 0)>conf
            pr(i, j,:) = NO_TEST*ones(length(num_tests));
        else
            % Do it quitely
            [~,out] = evalc("normalitytest(normalize(test_results{i,j}'))");
            pr(i,j,:) = out(:,2);
            fprintf('%d/%d\n',columns*(i-1)+j, rows*columns);
        end
    end
end

%% Matrix plotting
figure
t=tiledlayout(3,4);
t.TileSpacing = 'tight';
t.Padding = 'tight';
for i =1:num_tests
    if i<=7
        tile_num = i;
    else
        tile_num = i+1;
    end
    nexttile(tile_num);
    colormap default
    cmap = colormap;
    colormap(altermap(cmap, NO_TEST_COLOR));
    plot_matrix(n_range, p_range, pr(:,:,i));
    caxis([NO_TEST 1])
    cb = colorbar;
    set(cb,'Limits',[0 1])
    set_colorbar_title(cb, 'ℙ')
    xlabel('$n$','Interpreter','latex')
    ylabel('$p$','Interpreter','latex')
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    xticks(50:50:max(n_range))
    subtitle(titles{i})
end

%% Computing fit trends
pr_trends = zeros(rows, num_tests);
for ti=1:num_tests
    for ni=1:rows
        my_data = pr(ni,:,ti);
        switch summary_method
            case 'average'
                my_data = my_data(my_data ~= NO_TEST);
                pr_trends(ni,ti) = mean(my_data);
            case 'integrate'
                my_idxs = find(my_data ~= NO_TEST);
                p_vals = p_range(my_idxs);
                prob_vals = my_data(my_idxs);
                pr_trends(ni, ti) = trapz(p_vals,prob_vals)/range(p_vals);
        end
    end
end

%% Plotting fit rends
nexttile(8,[2,1])
for ti = 1:num_tests
    plot(n_range, pr_trends(:,ti))
    hold on
end
legend(titles);
xlabel('$n$','Interpreter','latex')
ylabel('< ℙ >')
axis([min(n_range),max(n_range),0,1])

%% Utility functions
function set_colorbar_title(cb, title)
    colorTitleHandle = get(cb,'Title');
    set(colorTitleHandle ,'String',title);
end

function new_map = altermap(old_map, NO_TEST_COLOR)
    new_map = [NO_TEST_COLOR ; old_map];
end

function plot_matrix(x, y, z)
    [X, Y] = meshgrid(x,y);
    s=surf(X, Y, z');
    s.EdgeColor='none';
    view(0, 90);
    axis([min(x) max(x) min(y) max(y)])
end
