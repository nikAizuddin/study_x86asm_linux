//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Function: find_weight
//
// Find the weight of image.
//    u = eigenface
//    L = original image
//    m = meanvector
//    n = numOfFaces
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 27-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[w] = find_weight(u, L, m, n)
    for i=1:1:n
        w(i) = u(:,i)'*(L(:,1)-m);
    end
endfunction