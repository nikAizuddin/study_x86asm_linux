;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; SSE2_ImageFilter_EDGradient.asm
;
; Perform edge detector based on image gradient.
;
; This source file contains function SSE2_ImageFilter_EDGradient().
; The function only executed when key "E" is pressed.
;
; Function SSE2_ImageFilter_EDGradient( void ) : void
;
;=====================================================================

section .text


SSE2_ImageFilter_EDGradient:

    pxor     xmm0, xmm0
    pxor     xmm1, xmm1
    movdqa   xmm7, [maskRemoveSign]

    lea    esi, [imgCurrent.pixel  + _COLUMNSIZE_32_ + _ROWSIZE_32_]
    lea    edi, [imgFiltered.pixel + _COLUMNSIZE_32_ + _ROWSIZE_32_]
    mov    edx, (_IMG_HEIGHT_ - 1)

align 16, nop
loopRow_EDGradient:

    mov    ecx, (_IMG_WIDTH_ - 1)

align 16, nop
loopColumn_EDGradient:

;XMM0 = left pixel
;XMM1 = right pixel
;XMM2 = above pixel
;XMM3 = below pixel

    movdqa   xmm0, [esi - _COLUMNSIZE_32_] ;left pixel
    movdqa   xmm1, [esi + _COLUMNSIZE_32_] ;right pixel
    movdqa   xmm2, [esi - _ROWSIZE_32_]    ;above pixel
    movdqa   xmm3, [esi + _ROWSIZE_32_]    ;below pixel

    movaps   xmm4, xmm0
    movaps   xmm5, xmm2

    subps    xmm4, xmm1
    subps    xmm5, xmm3

    andps    xmm4, xmm7
    andps    xmm5, xmm7
    addps    xmm4, xmm5

    movdqa   [edi], xmm4

    add    esi, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_32_
    sub    ecx, 1
    jnz    loopColumn_EDGradient

endloopColumn_EDGradient:

    sub    edx, 1
    jnz    loopRow_EDGradient

endloopRow_EDGradient:

    jmp    apply_ImageFilter

