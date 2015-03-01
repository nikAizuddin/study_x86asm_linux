;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; load_orldatabase_s08_faces.asm
;
;=====================================================================

section .text


load_orldatabase_s08_faces:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s1/1.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s01_01, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s01_01]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s01_01_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s01_01_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   Load "att_faces/orl_faces/s1/2.pgm" image
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s01_02, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s01_02]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s01_02_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s01_02_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;   Load "att_faces/orl_faces/s1/3.pgm" image
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s01_03, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s01_03]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s01_03_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s01_03_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s1/4.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s01_04, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s01_04]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s01_04_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s01_04_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s1/5.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s01_05, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s01_05]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s01_05_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s01_05_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s8/1.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s08_01, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s08_01]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
;Seek to the offset 0xe, which contains data pixels.
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s08_01_raw.pixel, image_size )
;Fill the imgRaw.pixel with the "32bit_image.bmp" pixels.
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s08_01_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s8/2.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s08_02, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s08_02]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s08_02_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s08_02_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s8/3.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s08_03, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s08_03]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s08_03_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s08_03_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s8/4.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s08_04, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s08_04]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s08_04_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s08_04_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s8/5.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s08_05, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s08_05]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s08_05_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s08_05_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s01_01 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s01_01_raw.pixel]
    lea    edi, [s01_01_float.pixel]
    pxor   xmm7, xmm7

align 16, nop
loop_convert_s01_01:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s01_01

endloop_convert_s01_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s01_02 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s01_02_raw.pixel]
    lea    edi, [s01_02_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s01_02:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s01_02

endloop_convert_s01_02:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s01_03 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s01_03_raw.pixel]
    lea    edi, [s01_03_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s01_03:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s01_03

endloop_convert_s01_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s01_04 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s01_04_raw.pixel]
    lea    edi, [s01_04_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s01_04:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s01_04

endloop_convert_s01_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s01_05 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s01_05_raw.pixel]
    lea    edi, [s01_05_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s01_05:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s01_05

endloop_convert_s01_05:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s08_01 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s08_01_raw.pixel]
    lea    edi, [s08_01_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

align 16, nop
loop_convert_s08_01:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s08_01

endloop_convert_s08_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s08_02 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s08_02_raw.pixel]
    lea    edi, [s08_02_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

align 16, nop
loop_convert_s08_02:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s08_02

endloop_convert_s08_02:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s08_03 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s08_03_raw.pixel]
    lea    edi, [s08_03_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s08_03:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s08_03

endloop_convert_s08_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s08_04 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s08_04_raw.pixel]
    lea    edi, [s08_04_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s08_04:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s08_04

endloop_convert_s08_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s08_05 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s08_05_raw.pixel]
    lea    edi, [s08_05_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s08_05:

    mov    bl, [esi]

    mov    eax, ebx
    shl    eax, 8
    add    eax, ebx
    shl    eax, 8
    add    eax, ebx

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edi], xmm0

    add    esi, _COLUMNSIZE_8_GRAY_
    add    edi, _COLUMNSIZE_32_BGRA_

    sub    ecx, 1
    jnz    loop_convert_s08_05

endloop_convert_s08_05:
