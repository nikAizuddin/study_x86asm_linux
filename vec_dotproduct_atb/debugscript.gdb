##       1         2         3         4         5         6         7
##34567890123456789012345678901234567890123456789012345678901234567890
######################################################################
## This is a debugscript for automated debugging the program.
##
## Author: Nik Mohamad Aizuddin bin Nik Azmi
##   Date: 09-APR-2015
######################################################################

break exit
run

## Print vector A
printf "\nContent of vector A\n"
set $i = 0
while($i<5)
    printf "%f ", *((&A)+$i)
    set $i = $i + 1
end
printf "\n"

## Print matrix B
printf "\nContent of vector B\n"
set $i = 0
while($i<5)
    printf "%f ", *((&B)+$i)
    set $i = $i + 1
end
printf "\n"

## Print result
printf "\n"
printf "C = A' * B\n"
printf "C = %f\n", *(&C)

continue
