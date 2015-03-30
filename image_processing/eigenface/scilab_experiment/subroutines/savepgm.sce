//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Function: savepgm(M, filename)
//
// Save the grayscale PGM image with 92*112 only.
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 29-MAR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[] = savepgm(M, filename)

    //////////////////////////////////////////////////////////////////
    // Create file descriptor for writing.
    //////////////////////////////////////////////////////////////////

    [fd, err] = mopen(filename, 'w');
    if err ~= 0
        disp('ERROR: Cant create image file!');
        return(-1);
    end


    //////////////////////////////////////////////////////////////////
    // Write the PGM Header.
    //////////////////////////////////////////////////////////////////

    str = 'P5'+...       // PGM Magic number
          ascii(10)+...  // Newline character
          '92 112'+...   // Width and Height of the matrix M
          ascii(10)+...  // Newline character
          '255'+...      // Maximum pixel value
          ascii(10);     // Newline character

    mputstr(str, fd);


    //////////////////////////////////////////////////////////////////
    // Write the data pixels from the matrix M to the file.
    //////////////////////////////////////////////////////////////////

    mput(M, 'uc', fd);


    mclose(fd);

endfunction