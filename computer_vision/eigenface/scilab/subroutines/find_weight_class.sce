//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Function: find_weight_class
//
// Find the weight of class.
//     u = eigenface
//     L = facevector
//     j = starting index for the facevector
//     m = meanvector
//     k = imagesPerPerson
//     n = numOfFaces
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 27-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[w] = find_weight_class(u, L, j, m, k, n)

    for i=1:1:k
        w(:,i) = find_weight(u, ...
                             L(:,j), ...
                             m, ...
                             n);
        j = j + 1;
    end

endfunction