;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; save_to_ximages.asm
;
;=====================================================================

section .text


save_to_ximages:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s01_01
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s01_01_float.pixel]
    lea    edi, [XImage_s01_01.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s01_01:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s01_01

endloop_save_XImage_s01_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s01_02
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s01_02_float.pixel]
    lea    edi, [XImage_s01_02.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s01_02:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s01_02

endloop_save_XImage_s01_02:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s01_03
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s01_03_float.pixel]
    lea    edi, [XImage_s01_03.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s01_03:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s01_03

endloop_save_XImage_s01_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s01_04
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s01_04_float.pixel]
    lea    edi, [XImage_s01_04.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s01_04:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s01_04

endloop_save_XImage_s01_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s01_05
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s01_05_float.pixel]
    lea    edi, [XImage_s01_05.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s01_05:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s01_05

endloop_save_XImage_s01_05:



;---------------------------------------------------------------------


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s02_01
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s02_01_float.pixel]
    lea    edi, [XImage_s02_01.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s02_01:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s02_01

endloop_save_XImage_s02_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s02_02
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s02_02_float.pixel]
    lea    edi, [XImage_s02_02.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s02_02:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s02_02

endloop_save_XImage_s02_02:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s02_03
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s02_03_float.pixel]
    lea    edi, [XImage_s02_03.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s02_03:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s02_03

endloop_save_XImage_s02_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s02_04
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s02_04_float.pixel]
    lea    edi, [XImage_s02_04.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s02_04:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s02_04

endloop_save_XImage_s02_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s02_05
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s02_05_float.pixel]
    lea    edi, [XImage_s02_05.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s02_05:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s02_05

endloop_save_XImage_s02_05:


;---------------------------------------------------------------------


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s03_01
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s03_01_float.pixel]
    lea    edi, [XImage_s03_01.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s03_01:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s03_01

endloop_save_XImage_s03_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s03_02
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s03_02_float.pixel]
    lea    edi, [XImage_s03_02.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s03_02:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s03_02

endloop_save_XImage_s03_02:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s03_03
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s03_03_float.pixel]
    lea    edi, [XImage_s03_03.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s03_03:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s03_03

endloop_save_XImage_s03_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s03_04
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s03_04_float.pixel]
    lea    edi, [XImage_s03_04.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s03_04:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s03_04

endloop_save_XImage_s03_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s03_05
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s03_05_float.pixel]
    lea    edi, [XImage_s03_05.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s03_05:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s03_05

endloop_save_XImage_s03_05:


;---------------------------------------------------------------------


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s04_01
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s04_01_float.pixel]
    lea    edi, [XImage_s04_01.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s04_01:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s04_01

endloop_save_XImage_s04_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s04_02
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s04_02_float.pixel]
    lea    edi, [XImage_s04_02.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s04_02:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s04_02

endloop_save_XImage_s04_02:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s04_03
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s04_03_float.pixel]
    lea    edi, [XImage_s04_03.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s04_03:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s04_03

endloop_save_XImage_s04_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s04_04
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s04_04_float.pixel]
    lea    edi, [XImage_s04_04.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s04_04:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s04_04

endloop_save_XImage_s04_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s04_05
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s04_05_float.pixel]
    lea    edi, [XImage_s04_05.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s04_05:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s04_05

endloop_save_XImage_s04_05:


;---------------------------------------------------------------------


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s05_01
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s05_01_float.pixel]
    lea    edi, [XImage_s05_01.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s05_01:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s05_01

endloop_save_XImage_s05_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s05_02
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s05_02_float.pixel]
    lea    edi, [XImage_s05_02.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s05_02:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s05_02

endloop_save_XImage_s05_02:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s05_03
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s05_03_float.pixel]
    lea    edi, [XImage_s05_03.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s05_03:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s05_03

endloop_save_XImage_s05_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s05_04
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s05_04_float.pixel]
    lea    edi, [XImage_s05_04.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s05_04:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s05_04

endloop_save_XImage_s05_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to XImage_s05_05
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [s05_05_float.pixel]
    lea    edi, [XImage_s05_05.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_save_XImage_s05_05:

    movdqa xmm0, [esi]

    cvtps2dq xmm0, xmm0 ;Convert single-precision to dword
    packssdw xmm0, xmm0 ;Convert dword to word
    packuswb xmm0, xmm0 ;Convert word to byte

    movd    [edi], xmm0

    add    esi, _COLUMNSIZE_32_BGRA_
    add    edi, _COLUMNSIZE_8_BGRA_

    sub    ecx, 1
    jnz    loop_save_XImage_s05_05

endloop_save_XImage_s05_05:


;---------------------------------------------------------------------
