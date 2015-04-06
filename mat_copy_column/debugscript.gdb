##       1         2         3         4         5         6         7
##34567890123456789012345678901234567890123456789012345678901234567890
######################################################################
## This is a debugscript for automated debugging the program.
##
## Author: Nik Mohamad Aizuddin bin Nik Azmi
##   Date: 06-APR-2015
######################################################################

break exit
run

## Print matrix A
printf "\nContent of matrix A\n"
set $i = 0
while($i<9)
    x/3fw &A+$i
    set $i = $i + 3
end

## Print matrix B
printf "\nContent of matrix B\n"
set $i = 0
while($i<9)
    x/3fw &B+$i
    set $i = $i + 3
end

continue
