switch(MODE)
    case 'nreg'
        addpath('../../lib/pathhomology')
    case 'dflag'
        addpath('../util')
end
switch(MODE)
    case 'nreg'
        load('../../mat/upper_betti1_check')
    case 'dflag'
        load('../../mat/upper_betti1_dflag_check')
end
%% Enumerate all undirected 3-path motifs
paths = cell(1, 4);
for m=0:3
    bin_vec = get_binary_vector(m,2);
    % Make sure middle edge is going forward
    bin_vec = [bin_vec(1) 0 bin_vec(2)];
    A = zeros(5,5);
    for j=1:3
        if bin_vec(j)==0
            A(j,j+1)=1;
        else
            A(j+1,j)=1;
        end
    end
    paths{m+1} = A;
end
% Now paths{m+1} is G_m for m=0,1,2,3

%% Enumerate all possible motifs
% There are 2^8 possible subsets J⊂L
motifs = cell(2^8, 4);
for i = 0:(2^8 - 1)
    vec = get_binary_vector(i, 8);
    B = zeros(5,5);
    B(end,1:4) = vec(1:4);
    B(1:4, end) = vec(5:end);
    for j = 1:4
        motifs{i+1,j} = paths{j} + B;
    end
    % TODO: Could just add motif_edge_count{i+1, j} = sum(vec) here?
end

%% Compute alpha
alpha = cellfun(@(x) compute_alpha(x, MODE), motifs);

%% Compute gamma by checking subgraphs
gamma = zeros(2^8, 4);
total = 2^8 * 4;
fprintf('Checking for subgraphs');
for i = 0:(2^8 - 1)
    for j=1:4
        loop_num = i*4 + j;
        % In this step we consider subgraphs of motif{i+1,j}
        % No need to check if already identified as a directed centre
        if alpha(i+1, j)
            gamma(i+1, j) = 1;
            fprintf('Skipping subgraph check %d/%d\n', loop_num, total);
            continue
        end
        % Loop over all possible subsets of linking edges
        for k=0:(2^8 - 1)
            % Take the subgraph
            subgraph_bin_vec = ...
                get_binary_vector(i,8) & get_binary_vector(k,8);
            % Find the index of this subgraph in motifs(:,j)
            idx = get_decimal_from_bin(subgraph_bin_vec) + 1;
            if alpha(idx, j)
                fprintf('Found subgraph for %d/%d\n', loop_num, total)
                gamma(i+1, j) = 1;
                break;
            end
        end
        fprintf('No subgraph found for %d/%d\n', loop_num, total)
    end
end


%% Count number of edges in each motif
motif_edge_count = cellfun(@edge_counter, motifs);

%% Count the number of directed centres with given #edges, for each m
Q = zeros(4,9);
for j = 1:4
    for count=0:8
        relevant_motifs = find(motif_edge_count(:,j)==count);
        Q(j,count+1) = sum(gamma(relevant_motifs,j));
    end
end

switch(MODE)
    case 'nreg'
        save('computed_Q')
    case 'dflag'
        save('computed_Q_flag')
end

%% Utility functions
function vec = get_binary_vector(num, digits)
    vec = dec2bin(num,digits) - '0';
end

function num = get_decimal_from_bin(vec)
    num = bin2dec(char(vec + '0'));
end

% We check whether centre connects to start and end first
% If that happens then we check that betti_1 = 0
function ret_val = compute_alpha(motif, MODE)
    if ~connectsInTwo(motif)
        ret_val = false;
        return
    end
    switch(MODE)
        case 'nreg'
            G = digraph(motif);
            ph = pathhomology(G,2,'symbolic');
            ret_val = (ph.betti(2) == 0);
        case 'dflag'
            bettis = flagser_hom(motif, 1,...
                "../../lib/flagser/flagser");
            ret_val = (bettis(2) == 0);
    end
end

function connects = connectsInTwo(motif)
    centreToEnd = (motif(4,end) == 1) || (motif(end,4) == 1);
    beginToCentre = (motif(1,end) == 1) || (motif(end,1) == 1);
    connects = centreToEnd && beginToCentre;
end

% Count the number of edges in J
function count = edge_counter(motif)
    count = sum(motif(end,:)) + sum(motif(:,end));
end
