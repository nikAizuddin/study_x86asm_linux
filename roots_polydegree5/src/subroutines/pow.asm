;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; pow.asm
;
; This source file contains function pow().
; The function will perform integer power on scalar single-precision.
;
; Function pow( base:XMM0, power:EAX ) : XMM0
;
;=====================================================================

global pow

section .text


pow:

    movdqa xmm1, xmm0
    sub    eax, 1
    jz     endloop_pow

loop_pow:

    mulss  xmm0, xmm1

    sub    eax, 1
    jnz    loop_pow

endloop_pow:

    ret
