function out = large_p_bound(n,p)
    out = nchoosek(n, 4)*factorial(4)*8*p^3*(1-p^3)^(n-4);
    out = out + nchoosek(n, 2)*p^2*(1-p^2)^(n-2);
    out = out + 2*nchoosek(n, 3)*(p^3)*(1-p^3)^(n-3);
end