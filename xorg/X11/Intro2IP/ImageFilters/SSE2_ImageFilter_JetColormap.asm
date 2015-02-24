;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; SSE2_ImageFilter_JetColormap.asm
;
; Perform edge detector based on image gradient.
;
; This source file contains function SSE2_ImageFilter_JetColormap().
; The function only executed when key "R" is pressed.
;
; Function SSE2_ImageFilter_JetColormap( void ) : void
;
;=====================================================================

section .text


SSE2_ImageFilter_JetColormap:

    movdqa xmm3, [blueChannelMask]
    movdqa xmm4, [greenChannelMask]
    movdqa xmm5, [redChannelMask]
    movdqa xmm6, [bgraChannelDivisor]

    lea    ebp, [jetColormap.pixel]
    lea    esi, [imgCurrent.pixel]
    lea    edi, [imgFiltered.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

align 16, nop
loop_JetColormap:

;Convert to grayscale by averaging color channels

    movdqa xmm0, [esi]
    movdqa xmm1, xmm0
    movdqa xmm2, xmm0

    andps  xmm0, xmm3 ;b
    andps  xmm1, xmm4 ;g
    andps  xmm2, xmm5 ;r

    psrldq xmm2, 8
    psrldq xmm1, 4

    addss  xmm0, xmm1
    addss  xmm0, xmm2

    divss  xmm0, xmm6
    movdqa xmm1, xmm0
    movdqa xmm2, xmm0

    pslldq xmm1, 4
    pslldq xmm2, 8
    addps  xmm0, xmm1
    addps  xmm0, xmm2

    cvtss2si eax, xmm0
    mov      ebx, 16
    xor      edx, edx
    mul      ebx

    movdqa xmm0, [ebp+eax]

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_32_

    sub    ecx, 1
    jnz    loop_JetColormap

endloop_JetColormap:

    jmp    apply_ImageFilter

