;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_kernel.inc
;
; This header file containts structures.
;
;=====================================================================

section .bss

    args:
        .param1:             resd 1
        .param2:             resd 1
        .param3:             resd 1
        .param4:             resd 1

    poll: 
        .fd:                 resd 1
        .events:             resw 1
        .revents:            resw 1