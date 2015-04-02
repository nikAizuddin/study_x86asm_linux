    function[Y] = vectNorm(X)
        Y = 0;
        for i=1:1:size(X,'r')
            Y = Y + X(i)^2;
        end
        Y = sqrt(Y);
    endfunction