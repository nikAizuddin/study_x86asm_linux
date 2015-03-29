function[M] = scale_to_255(A)

    M = round(255 * (A / max(A)));
    M = abs(M);

endfunction