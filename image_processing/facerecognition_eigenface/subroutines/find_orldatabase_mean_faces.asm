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

    mov    edx, 25 ;s01_01 -> s05_05
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
;   Subtract Mean for s01_01
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s01_01_float.pixel]
    lea    ebx, [meanFaces.pixel]
    lea    edi, [s01_01_meanSubtracted.pixel]

loop_subtractMean:

    movdqa xmm0, [ebx]

    ;s01_01
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*0)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*0)], xmm1

    ;s01_02
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*1)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*1)], xmm1

    ;s01_03
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*2)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*2)], xmm1

    ;s01_04
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*3)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*3)], xmm1

    ;s01_05
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*4)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*4)], xmm1

    ;s02_01
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*5)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*5)], xmm1

    ;s02_02
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*6)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*6)], xmm1

    ;s02_03
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*7)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*7)], xmm1

    ;s02_04
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*8)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*8)], xmm1

    ;s02_05
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*9)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*9)], xmm1

    ;s03_01
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*10)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*10)], xmm1

    ;s03_02
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*11)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*11)], xmm1

    ;s03_03
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*12)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*12)], xmm1

    ;s03_04
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*13)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*13)], xmm1

    ;s03_05
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*14)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*14)], xmm1

    ;s04_01
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*15)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*15)], xmm1

    ;s04_02
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*16)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*16)], xmm1

    ;s04_03
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*17)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*17)], xmm1

    ;s04_04
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*18)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*18)], xmm1

    ;s04_05
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*19)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*19)], xmm1

    ;s05_01
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*20)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*20)], xmm1

    ;s05_02
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*21)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*21)], xmm1

    ;s05_03
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*22)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*22)], xmm1

    ;s05_04
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*23)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*23)], xmm1

    ;s05_05
    movdqa xmm1, [esi + (_IMG_SIZE_32_BGRA_*24)]
    subps  xmm1, xmm0
    movdqa [edi + (_IMG_SIZE_32_BGRA_*24)], xmm1

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
