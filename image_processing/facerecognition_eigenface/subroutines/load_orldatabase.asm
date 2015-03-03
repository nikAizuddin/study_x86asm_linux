;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; load_orldatabase_s08_faces.asm
;
;=====================================================================

section .text


load_orldatabase:


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
;
;   Load "att_faces/orl_faces/s1/2.pgm" image
;
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
;
;   Load "att_faces/orl_faces/s1/3.pgm" image
;
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
;   Load "att_faces/orl_faces/s2/1.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s02_01, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s02_01]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s02_01_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s02_01_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s2/2.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s02_02, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s02_02]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s02_02_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s02_02_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s2/3.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s02_03, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s02_03]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s02_03_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s02_03_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s2/4.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s02_04, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s02_04]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s02_04_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s02_04_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s2/5.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s02_05, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s02_05]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s02_05_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s02_05_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s3/1.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s03_01, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s03_01]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s03_01_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s03_01_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s3/2.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s03_02, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s03_02]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s03_02_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s03_02_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s3/3.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s03_03, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s03_03]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s03_03_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s03_03_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s3/4.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s03_04, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s03_04]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s03_04_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s03_04_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s3/5.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s03_05, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s03_05]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s03_05_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s03_05_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s4/1.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s04_01, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s04_01]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s04_01_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s04_01_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s4/2.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s04_02, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s04_02]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s04_02_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s04_02_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s4/3.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s04_03, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s04_03]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s04_03_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s04_03_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s4/4.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s04_04, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s04_04]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s04_04_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s04_04_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s4/5.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s04_05, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s04_05]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s04_05_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s04_05_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s5/1.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s05_01, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s05_01]
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

;READ( image_fd, @s05_01_raw.pixel, image_size )
;Fill the imgRaw.pixel with the "32bit_image.bmp" pixels.
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s05_01_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s5/2.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s05_02, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s05_02]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s05_02_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s05_02_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s5/3.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s05_03, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s05_03]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s05_03_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s05_03_raw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "att_faces/orl_faces/s5/4.pgm" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_s05_04, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s05_04]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s05_04_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s05_04_raw.pixel]
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

;image_fd = OPEN( @path_s05_05, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_s05_05]
    mov    ecx, _O_RDONLY_
    int    0x80
    mov    [image_fd], eax

;LSEEK( image_fd, 0xe, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0xe
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @s05_05_raw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [s05_05_raw.pixel]
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
;   Convert grayscale s02_01 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s02_01_raw.pixel]
    lea    edi, [s02_01_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s02_01:

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
    jnz    loop_convert_s02_01

endloop_convert_s02_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s02_02 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s02_02_raw.pixel]
    lea    edi, [s02_02_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s02_02:

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
    jnz    loop_convert_s02_02

endloop_convert_s02_02:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s02_03 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s02_03_raw.pixel]
    lea    edi, [s02_03_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s02_03:

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
    jnz    loop_convert_s02_03

endloop_convert_s02_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s02_04 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s02_04_raw.pixel]
    lea    edi, [s02_04_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s02_04:

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
    jnz    loop_convert_s02_04

endloop_convert_s02_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s02_05 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s02_05_raw.pixel]
    lea    edi, [s02_05_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s02_05:

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
    jnz    loop_convert_s02_05

endloop_convert_s02_05:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s03_01 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s03_01_raw.pixel]
    lea    edi, [s03_01_float.pixel]
    pxor   xmm7, xmm7

align 16, nop
loop_convert_s03_01:

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
    jnz    loop_convert_s03_01

endloop_convert_s03_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s03_02 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s03_02_raw.pixel]
    lea    edi, [s03_02_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s03_02:

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
    jnz    loop_convert_s03_02

endloop_convert_s03_02:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s03_03 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s03_03_raw.pixel]
    lea    edi, [s03_03_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s03_03:

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
    jnz    loop_convert_s03_03

endloop_convert_s03_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s03_04 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s03_04_raw.pixel]
    lea    edi, [s03_04_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s03_04:

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
    jnz    loop_convert_s03_04

endloop_convert_s03_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s03_05 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s03_05_raw.pixel]
    lea    edi, [s03_05_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s03_05:

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
    jnz    loop_convert_s03_05

endloop_convert_s03_05:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s04_01 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s04_01_raw.pixel]
    lea    edi, [s04_01_float.pixel]
    pxor   xmm7, xmm7

align 16, nop
loop_convert_s04_01:

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
    jnz    loop_convert_s04_01

endloop_convert_s04_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s04_02 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s04_02_raw.pixel]
    lea    edi, [s04_02_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s04_02:

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
    jnz    loop_convert_s04_02

endloop_convert_s04_02:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s04_03 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s04_03_raw.pixel]
    lea    edi, [s04_03_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s04_03:

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
    jnz    loop_convert_s04_03

endloop_convert_s04_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s04_04 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s04_04_raw.pixel]
    lea    edi, [s04_04_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s04_04:

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
    jnz    loop_convert_s04_04

endloop_convert_s04_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s04_05 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s04_05_raw.pixel]
    lea    edi, [s04_05_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s04_05:

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
    jnz    loop_convert_s04_05

endloop_convert_s04_05:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s05_01 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s05_01_raw.pixel]
    lea    edi, [s05_01_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

align 16, nop
loop_convert_s05_01:

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
    jnz    loop_convert_s05_01

endloop_convert_s05_01:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s05_02 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s05_02_raw.pixel]
    lea    edi, [s05_02_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

align 16, nop
loop_convert_s05_02:

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
    jnz    loop_convert_s05_02

endloop_convert_s05_02:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s05_03 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s05_03_raw.pixel]
    lea    edi, [s05_03_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s05_03:

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
    jnz    loop_convert_s05_03

endloop_convert_s05_03:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s05_04 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s05_04_raw.pixel]
    lea    edi, [s05_04_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s05_04:

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
    jnz    loop_convert_s05_04

endloop_convert_s05_04:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert grayscale s05_05 to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize loop
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    lea    esi, [s05_05_raw.pixel]
    lea    edi, [s05_05_float.pixel]
    xor    ebx, ebx
    pxor   xmm7, xmm7

loop_convert_s05_05:

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
    jnz    loop_convert_s05_05

endloop_convert_s05_05:
