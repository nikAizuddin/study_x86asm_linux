;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data.inc
;
; This header file contains data.
;
;=====================================================================

section .bss

    s01_01_raw:    resb (FACE_WIDTH*FACE_HEIGHT*1)


section .data

    filename_s01_01:    db "att_faces/orl_faces/s1/1.pgm",0
