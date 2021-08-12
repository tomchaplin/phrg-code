function out = flagser_hom(A,max_dim,flagser_path)
    % Format contents of flagser file
    flagser_file = mat_to_flag(A);
    % Get temporary files
    tfin = tempname;
    tfout = tempname;
    % Write flagser file
    f = fopen(tfin,'w');
    fprintf(f, flagser_file);
    fclose(f);
    % Run flagser
    cmd = sprintf('%s --out %s --max-dim %d %s',...
        flagser_path, tfout, max_dim, tfin);
    [~, ~] = system(cmd);
    % Collect betti numbers from output file
    out = str2num(get_file_at_line(tfout, 4));
    % Clean up temp files
    prevState = recycle('off');
    delete(tfin);
    delete(tfout);
    recycle(prevState);
end

function out = get_file_at_line(filename, linenum)
    f = fopen(filename, 'r');
    if linenum>1
        for i=1:(linenum-1)
            [~] = fgetl(f);
        end
    end
    out = fgetl(f);
    fclose(f);
end
