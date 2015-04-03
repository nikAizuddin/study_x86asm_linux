//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Calculate eigenvalue and eigenvector using QR Decomposition.
//
// The purpose of this function, is to calculate the eigenvalues and
// eigenvectors, specifically for Computer Vision (Eigenface).
// So, I can't say my calculations will give 100% correct answer
// for all possible matrices.
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 03-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[S, A] = eigen_qr(A)


    //////////////////////////////////////////////////////////////////
    // Perform 20 iterations of QR Decomposition, to find the
    // eigenvalues and eigenvectors.
    // I think 20 iterations are already good, but you can increase
    // the number of iterations for extra accuracy.
    //////////////////////////////////////////////////////////////////

    [Q,R] = qr_decomposition(A);
    A = Q*R;
    S = Q;

    for i=2:1:20
        A = R*Q;
        [Q,R] = qr_decomposition(A);
        A = Q*R;
        S = S*Q;
    end


    //////////////////////////////////////////////////////////////////
    // Normalize eigenvectors to 1.0, so that the range of the vector
    // is between 0.0 -> 1.0.
    //////////////////////////////////////////////////////////////////

    for i=1:1:size(A,'c')
        S(:,i) = S(:,i)./max(abs(S(:,i)));
    end


endfunction