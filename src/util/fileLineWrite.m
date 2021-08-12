function fileLineWrite(filename, permission, num_lines, f, varargin)
    fid = fopen(filename, permission);
    for line_num = 1:num_lines
        % Write this line
        to_write = f(line_num);
        fprintf(fid, '%s\n', to_write);
    end
    fclose(fid);
end
