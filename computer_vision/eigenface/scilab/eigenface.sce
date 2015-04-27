//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Recognize face by using Eigenface algorithm.
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 29-MAR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////


function[] = eigenface()

    stacksize('max');
    numOfPerson     = 10;
    imagesPerPerson = 5;
    numOfFaces      = numOfPerson * imagesPerPerson;


    //////////////////////////////////////////////////////////////////
    // STEP 1: Load all images from the ORL Database.
    // First, we have to fill the variable face[] with the
    // images from the database.
    //////////////////////////////////////////////////////////////////

    k = 1;
    for i=1:1:numOfPerson
    for j=1:1:imagesPerPerson
        filename = "att_faces/orl_faces/s"+...
                   string(i)+...
                   "/"+...
                   string(j)+...
                   ".pgm";
        face(k,:) = loadpgm(filename);
        k = k + 1;
    end
    end


    //////////////////////////////////////////////////////////////////
    // STEP 2: Convert to face vector space.
    // Principle Component Analysis doesn't work directly on images.
    // it must first vectorized from, for example N*N to N^2.
    //////////////////////////////////////////////////////////////////

    facevector = face';


    //////////////////////////////////////////////////////////////////
    // STEP 3: Find mean value from all faces.
    // We must find the common features of human faces, so that when
    // we subtract it with the faces, we will get the unique feature.
    //////////////////////////////////////////////////////////////////

    [rows, cols] = size(facevector);
    for r=1:1:rows
        total = 0;
        for c=1:1:cols
            total = total + facevector(r,c);
        end
        meanvector(r) = total / cols;
    end


    //////////////////////////////////////////////////////////////////
    // STEP 4: Find facevector - mean.
    // The result is a matrix, and this matrix will have 0 mean.
    // Also, the matrix will contains only unique feature of faces.
    //////////////////////////////////////////////////////////////////

    meansubtvector = facevector - repmat(meanvector,1,cols);


    //////////////////////////////////////////////////////////////////
    // STEP 5: Find matrix L
    // Matrix L is a covariance matrix, but we use a different
    // technique to find the covariance.
    //////////////////////////////////////////////////////////////////

    L = meansubtvector' * meansubtvector;


    //////////////////////////////////////////////////////////////////
    // STEP 6: Find eigenvalue and eigenvector of the matrix L.
    //////////////////////////////////////////////////////////////////

    [eigenvector_L, eigenvalues_L] = eigen_qr(L);


    //////////////////////////////////////////////////////////////////
    // STEP 7: Find eigenface.
    // The eigenface is actually the eigenvector of the covariance
    // matrix with "Original Dimensionality". However, the matrix L
    // is a covariance matrix with "Reduced Dimensionality". To find
    // the eigenvector of a covariance matrix with
    // "Original Dimensionality", we have to multiply the eigenvector
    // of matrix L with the matrix meansubtvector.
    //////////////////////////////////////////////////////////////////

    for i=1:1:numOfFaces
        eigenface(:,i)  = meansubtvector * eigenvector_L(:,i);
    end


    //////////////////////////////////////////////////////////////////
    // STEP 8: Scale eigenface to 255.
    // First, we have to normalized the eigenvector so that the
    // range of the vector is within 0.0 -> 1.0.
    // Then, we can scale it to 255 to visualize it.
    //////////////////////////////////////////////////////////////////

    for i=1:1:numOfFaces
        Scaled_eigenface(:,i) = scale_to_255(eigenface(:,i));
    end


    //////////////////////////////////////////////////////////////////
    // The Face database is now prepared, lets save the result for
    // inspection.
    //////////////////////////////////////////////////////////////////

    for i=1:1:numOfFaces
        filename = "output/face_"+string(i)+".pgm";
        savepgm( facevector(:,i), filename);
    end

    for i=1:1:numOfFaces
        filename = "output/meansubt_"+string(i)+".pgm";
        savepgm( abs(meansubtvector(:,i)), filename);
    end

    for i=1:1:numOfFaces
        filename = "output/eigenface_"+string(i)+".pgm";
        savepgm(Scaled_eigenface(:,i), filename);
    end

    savepgm(matrix(meanvector, 112, 92), 'output/mean.pgm');


    //////////////////////////////////////////////////////////////////
    // STEP 9: Recognize the face (Person 1 to Person 7 only)
    //////////////////////////////////////////////////////////////////

    // Find weight for target image
    targetFilename = "att_faces/orl_faces/s7/10.pgm"
    targetImg(:,1) = loadpgm(targetFilename);
    targetW        = find_weight(eigenface, ...
                                 targetImg, ...
                                 meanvector, ...
                                 numOfFaces);

    // Find weight for the face class 1 (person 1)
    wClass1 = find_weight_class(eigenface, ...
                                facevector, ...
                                1, ...
                                meanvector, ...
                                imagesPerPerson, ...
                                numOfFaces);

    // Find weight for the face class 2 (person 2)
    wClass2 = find_weight_class(eigenface, ...
                                facevector, ...
                                6, ...
                                meanvector, ...
                                imagesPerPerson, ...
                                numOfFaces);

    // Find weight for the face class 3 (person 3)
    wClass3 = find_weight_class(eigenface, ...
                                facevector, ...
                                11, ...
                                meanvector, ...
                                imagesPerPerson, ...
                                numOfFaces);

    // Find weight for the face class 4 (person 4)
    wClass4 = find_weight_class(eigenface, ...
                                facevector, ...
                                16, ...
                                meanvector, ...
                                imagesPerPerson, ...
                                numOfFaces);

    // Find weight for the face class 5 (person 5)
    wClass5 = find_weight_class(eigenface, ...
                                facevector, ...
                                21, ...
                                meanvector, ...
                                imagesPerPerson, ...
                                numOfFaces);

    // Find weight for the face class 6 (person 6)
    wClass6 = find_weight_class(eigenface, ...
                                facevector, ...
                                26, ...
                                meanvector, ...
                                imagesPerPerson, ...
                                numOfFaces);

    // Find weight for the face class 7 (person 7)
    wClass7 = find_weight_class(eigenface, ...
                                facevector, ...
                                31, ...
                                meanvector, ...
                                imagesPerPerson, ...
                                numOfFaces);

    // Euclidean distant between target weight and class1 weight.
    d1 = sqrt( abs((targetW(:,1).^2) - (wClass1(:,1).^2)) );

    // Euclidean distant between target weight and class2 weight.
    d2 = sqrt( abs((targetW(:,1).^2) - (wClass2(:,1).^2)) );

    // Euclidean distant between target weight and class3 weight.
    d3 = sqrt( abs((targetW(:,1).^2) - (wClass3(:,1).^2)) );

    // Euclidean distant between target weight and class4 weight.
    d4 = sqrt( abs((targetW(:,1).^2) - (wClass4(:,1).^2)) );

    // Euclidean distant between target weight and class5 weight.
    d5 = sqrt( abs((targetW(:,1).^2) - (wClass5(:,1).^2)) );

    // Euclidean distant between target weight and class6 weight.
    d6 = sqrt( abs((targetW(:,1).^2) - (wClass6(:,1).^2)) );

    // Euclidean distant between target weight and class7 weight.
    d7 = sqrt( abs((targetW(:,1).^2) - (wClass7(:,1).^2)) );

    // Average distant
    avgD1 = mean(d1);
    avgD2 = mean(d2);
    avgD3 = mean(d3);
    avgD4 = mean(d4);
    avgD5 = mean(d5);
    avgD6 = mean(d6);
    avgD7 = mean(d7);

    // Find the lowest distant
    [value, index] = min([avgD1, avgD2, avgD3, avgD4, avgD5, ...
                          avgD6, avgD7]);

    printf("\nRESULT\n");

    printf("\nThe program uses a sample unknown face from the folder:\n");
    printf("%s.\n",targetFilename);
    printf("Lets see if the program can recognize the face or not.\n\n");

    printf("average distant with class 1 = %.4f\n",avgD1);
    printf("average distant with class 2 = %.4f\n",avgD2);
    printf("average distant with class 3 = %.4f\n",avgD3);
    printf("average distant with class 4 = %.4f\n",avgD4);
    printf("average distant with class 5 = %.4f\n",avgD5);
    printf("average distant with class 6 = %.4f\n",avgD6);
    printf("average distant with class 7 = %.4f\n",avgD7);

    printf("\nBased on the value of average euclidean distant,\n");
    printf("    the target person is from folder s%d\n",index);
    printf("    because it is nearest to the class %d\n",index);

endfunction
