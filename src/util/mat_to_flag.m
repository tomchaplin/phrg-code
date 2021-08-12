function str = mat_to_flag(A)
    [nn,~] = size(A);
    str = sprintf("dim 0:\n");
    v_fmt = repmat('%d ',1, nn);
    v_fmt = v_fmt(1:(end-1))+"\n";
    v_str = sprintf(v_fmt, zeros(1,nn));
    str = str + v_str + sprintf("dim 1:");
    for i = 1:nn
        for j = 1:nn
            if A(i, j)
                str = str + sprintf("\n%d %d 0", i-1, j-1);
            end
        end
    end
end

