;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; find_orldatabase_mean_faces.asm
;
;=====================================================================

section .text


find_orldatabase_mean_faces:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find mean
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    xor    ecx, ecx
    movdqa xmm2, [meanDivisor]
    lea    edi, [faceMean.pixel]

loop_find_mean:

    mov    edx, 5 ;s08_01 -> s08_05
    pxor   xmm1, xmm1
    lea    esi, [s08_01_float.pixel + ecx]

subloop_find_mean:

    movdqa xmm0, [esi]
    addps  xmm1, xmm0

    add    esi, (_IMG_WIDTH_*_IMG_HEIGHT_*_COLUMNSIZE_32_BGRA_)

    sub    edx, 1
    jnz    subloop_find_mean

endsubloop_find_mean:

    divps  xmm1, xmm2
    movdqa [edi], xmm1
    add    edi, _COLUMNSIZE_32_BGRA_

    add    ecx, _COLUMNSIZE_32_BGRA_
    cmp    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_*_COLUMNSIZE_32_BGRA_)
    jne    loop_find_mean

endloop_find_mean:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Normalize s08_01 to s08_05
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s08_01_float.pixel]
    lea    ebx, [faceMean.pixel]
    lea    edi, [s08_01_normalized.pixel]

loop_normalize:

    movdqa xmm0, [ebx]

    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*0)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*0)], xmm1

    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*1)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*1)], xmm1

    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*2)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*2)], xmm1

    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*3)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*3)], xmm1

    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*4)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*4)], xmm1

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_32_BGRA_
    add    ebx, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_normalize

endloop_normalize:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;    lea    esi, [s08_04_normalized.pixel]
    lea    esi, [faceMean.pixel]
    lea    edi, [XImage.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage

endloop_save_XImage:
