function[] = savepgm(m, filename)

    [fd, err] = mopen(filename, 'w');
    if err ~= 0
        disp('ERROR: Cant create image file!');
        return(-1);
    end

    str = 'P5' + ascii(10) + '92 112' + ascii(10) + '255' + ascii(10);
    mputstr(str, fd);
    mput(m, 'uc', fd);

    mclose(fd);

endfunction