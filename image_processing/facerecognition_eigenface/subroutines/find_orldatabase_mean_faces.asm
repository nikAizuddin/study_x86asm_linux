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
    lea    edi, [meanFaces.pixel]

loop_find_mean:

    mov    edx, 15 ;s01_01 -> s08_05
    pxor   xmm1, xmm1
    lea    esi, [s01_01_float.pixel + ecx]

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
;   Get unique feature of a face by subtracting mean
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s01_01_float.pixel]
    lea    ebx, [meanFaces.pixel]
    lea    edi, [s01_01_meanSubtracted.pixel]

loop_subtractMean:

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
    jnz    loop_subtractMean

endloop_subtractMean:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Normalize meanFaces 0 -> 255
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    pxor   xmm1, xmm1
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [meanFaces.pixel]

loop_findMax_meanFaces:

    movdqa  xmm0, [esi]
    ucomiss xmm0, xmm1
    jb      meanFaces_pxIntensity_notHighest

meanFaces_pxIntensity_highest:

    movdqa  xmm1, xmm0

meanFaces_pxIntensity_notHighest:

    add    esi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_findMax_meanFaces

endloop_findMax_meanFaces:


    movdqa xmm3, xmm1
    pslldq xmm1, 4
    addss  xmm1, xmm3
    pslldq xmm1, 4
    addss  xmm1, xmm3

    movdqa xmm2, [maxPixelIntensity]
    divps  xmm2, xmm1

    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [meanFaces.pixel]
    lea    edi, [meanFaces_normalized.pixel]

loop_normalize_meanFaces:

    movdqa xmm0, [esi]
    mulps  xmm0, xmm2
    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_normalize_meanFaces

endloop_normalize_meanFaces:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImages
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%include "subroutines/save_to_ximages.asm"
