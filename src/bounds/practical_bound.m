function bound = practical_bound(n, p, Q_file)
    load(Q_file,'Q');
    C = [2 4 4 4];
    bound = 0;
    bound = bound + probBad3Path(n,p,Q,C);
    bound = bound + probBad3Cycle(n, p);
    bound = bound + probBad2Cycle(n, p);
end

function bound = probBad3Path(n, p, Q, C)
    bound = 0;
    for m=0:3
        prob_Ask = 0;
        for l=0:8
            prob_Ask = prob_Ask + Q(m+1,l+1)*p^l*(1-p)^(8-l);
        end
        bound = bound + p^3*(1-p)^(C(m+1))*(1- prob_Ask)^(n-4);
    end
    bound = nchoosek(n, 4) * factorial(4) * bound;
end

function bound = probBad3Cycle(n, p)
    bound = 2 * nchoosek(n, 3) * p^3 * (1-p^3)^(2*n-6);
end

function bound = probBad2Cycle(n, p)
    bound = nchoosek(n, 2) * p^2 * (1-p^2)^(2*n-4);
end
