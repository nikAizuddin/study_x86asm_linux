//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Find eigenfaces
//
// Perform calculations to find the eigenfaces from 400 images.
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 29-MAR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////


function[] = main()

    stacksize('max');
    numOfPerson     = 40;
    imagesPerPerson = 10;
    numOfFaces      = numOfPerson * imagesPerPerson;


    //////////////////////////////////////////////////////////////////
    // STEP 1: Load all images from the ORL Database.
    // First, we have to fill the variable face[] with the
    // images from the database.
    //////////////////////////////////////////////////////////////////

    k = 1;
    for i=1:1:numOfPerson
    for j=1:1:imagesPerPerson
        filename = "../att_faces/orl_faces/s"+...
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

    [eigenvector_L, eigenvalues_L] = spec(L);


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
        eigenface(:,i) = scale_to_255(eigenface(:,i));
    end


    //////////////////////////////////////////////////////////////////
    // That's all folks :)
    // The calculation ends here. The next step is to print the
    // result to "output" folder.
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
        savepgm(eigenface(:,i), filename);
    end

    savepgm(matrix(meanvector, 112, 92), 'output/mean.pgm');

endfunction