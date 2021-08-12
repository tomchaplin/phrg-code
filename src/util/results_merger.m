%clear
switch(MODE)
    case 'nreg'
        load('../../mat/lower_betti1_check')
    case 'dflag'
        load('../../mat/lower_betti1_dflag_check')
end
ex_n = n_range;
ex_p = p_range;
lower_results = test_results;
offset = length(p_range);
switch(MODE)
    case 'nreg'
        load('../../mat/upper_betti1_check')
    case 'dflag'
        load('../../mat/upper_betti1_dflag_check')
end
ex_p = [ex_p p_range];
upper_results = test_results;

test_results = cell(length(ex_n), length(ex_p));
[ex_p, I] = sort(ex_p);
n_range = ex_n;
p_range = ex_p;

if strcmp(MODE,'nreg')
    % We have to load up a slightly smaller n_range for nreg path
    load('../../mat/upper_betti1_check','n_range')
end

for ni = 1:length(ex_n)
    for pi = 1:length(ex_p)
        if I(pi)<=offset
            test_results{ni,pi}=lower_results{ni,I(pi)};
        elseif ni<=length(n_range)
            test_results{ni,pi}=upper_results{ni,I(pi)-offset};
        end
    end
end
