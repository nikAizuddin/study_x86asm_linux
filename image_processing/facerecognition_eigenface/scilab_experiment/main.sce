function[] = main()

    num_of_person = 40;
    photos_each_person = 10;
    num_of_faces = num_of_person * photos_each_person;

    // STEP 1: Load images
    tic();
    k = 1;
    for i=1:1:num_of_person
        for j=1:1:photos_each_person
            filename = "../att_faces/orl_faces/s"+...
                       string(i)+...
                       "/"+...
                       string(j)+...
                       ".pgm";
            face(k,:) = loadpgm(filename);
            k = k + 1;
        end
    end
    disp("STEP 1: Load images = "+string(toc()));

    // STEP 2: Convert to face vector space
    tic();
    facevector = face';
    disp("STEP 2: Convert to face vector space = "+string(toc()));

    // STEP 3: Find mean
    tic();
    [rows, cols] = size(facevector);
    for r=1:1:rows
        total = 0;
        for c=1:1:cols
            total = total + facevector(r,c);
        end
        meanvector(r) = total / cols;
    end
    disp("STEP 3: Find mean = "+string(toc()));

    // STEP 4: Find facevector - mean
    tic();
    meansubtvector = facevector - repmat(meanvector,1,cols);
    disp("STEP 4: Find facevector - mean: "+string(toc()));

    // STEP 5: Find matrix L
    tic();
    L = meansubtvector' * meansubtvector;
    disp("STEP 5: Find matrix L: "+string(toc()));

    // STEP 6: Find eigenvalue and eigenvector of L
    tic();
    [eigenvector_L, eigenvalues_L] = spec(L);
    disp("STEP 6: Calculate eigenvector of L: "+string(toc()));

    // STEP 7: Find eigenface
    tic();
    for i=1:1:num_of_faces
        eigenface(:,i)  = meansubtvector * eigenvector_L(:,i);
    end
    disp("STEP 7: Find eigenface: "+string(toc()));

    // STEP 8: Scale eigenface to 255
    tic();
    for i=1:1:num_of_faces
        eigenface(:,i)  = scale_to_255(eigenface(:,i));
    end
    disp("STEP 8: Scale eigenface to 255: "+string(toc()));


    // Print results

    for i=1:1:num_of_faces
        filename = "output/face_"+string(i)+".pgm";
        savepgm( facevector(:,i), filename);
    end

    for i=1:1:num_of_faces
        filename = "output/meansubt_"+string(i)+".pgm";
        savepgm( abs(meansubtvector(:,i)), filename);
    end

    for i=1:1:num_of_faces
        filename = "output/eigenface_"+string(i)+".pgm";
        savepgm(eigenface(:,i), filename);
    end

    savepgm(matrix(meanvector, 112, 92), 'output/mean.pgm');

endfunction