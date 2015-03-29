function[m] = loadpgm(filename)

    [fd, err] = mopen(filename, 'r');
    if err ~= 0
        disp('ERROR: Cant open image file!');
        return(-1);
    end

    mseek(14, fd, 'set');
    m = mget(92*112, 'uc', fd);

    mclose(fd);

endfunction