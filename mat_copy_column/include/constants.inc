;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; constants.inc
;
; This header file contains constant symbols.
;
;=====================================================================

; System call numbers
SYSCALL_EXIT    equ    1 ;exit the program

; Program constants
NUM_OF_COLUMNS  equ    3 ;number of columns
NUM_OF_ROWS     equ    3 ;number of rows
COLUMNSIZE      equ    4 ;size of a column
ROWSIZE         equ    (NUM_OF_COLUMNS * COLUMNSIZE)
