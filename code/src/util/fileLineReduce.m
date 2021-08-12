function init_val = fileLineReduce(filename, f, init_val, varargin)
    fid = fopen(filename)

    line_num = 1;
    next_line = fgetl(fid);
    while ischar(next_line)
        % Reduce this line
        init_val = f(init_val, next_line, line_num);
        % Get ready for next line
        next_line = fgetl(fid)
        line_num = line_num + 1;
    end

    fclose(fid);
end
