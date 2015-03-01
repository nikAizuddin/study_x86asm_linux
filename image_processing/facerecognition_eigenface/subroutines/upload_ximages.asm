;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; upload_ximages.asm
;
;=====================================================================

section .text


upload_ximages:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;
;   Upload XImage_s01_01.pixel to mainWindow.s01_01_pid
;   by using PutImage request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


;Initialize putImage structure
;We will use this structure as the PutImage request.

    mov    eax, [mainWindow.s01_01_pid]
    mov    ebx, [mainWindow.s01_02_pid]
    mov    ecx, [mainWindow.s01_03_pid]
    mov    edx, [mainWindow.s01_04_pid]
    mov    esi, [mainWindow.s01_05_pid]
    mov    [putImage_s01_01.drawable], eax
    mov    [putImage_s01_02.drawable], ebx
    mov    [putImage_s01_03.drawable], ecx
    mov    [putImage_s01_04.drawable], edx
    mov    [putImage_s01_05.drawable], esi

    mov    eax, [mainWindow.s02_01_pid]
    mov    ebx, [mainWindow.s02_02_pid]
    mov    ecx, [mainWindow.s02_03_pid]
    mov    edx, [mainWindow.s02_04_pid]
    mov    esi, [mainWindow.s02_05_pid]
    mov    [putImage_s02_01.drawable], eax
    mov    [putImage_s02_02.drawable], ebx
    mov    [putImage_s02_03.drawable], ecx
    mov    [putImage_s02_04.drawable], edx
    mov    [putImage_s02_05.drawable], esi

    mov    eax, [mainWindow.s03_01_pid]
    mov    ebx, [mainWindow.s03_02_pid]
    mov    ecx, [mainWindow.s03_03_pid]
    mov    edx, [mainWindow.s03_04_pid]
    mov    esi, [mainWindow.s03_05_pid]
    mov    [putImage_s03_01.drawable], eax
    mov    [putImage_s03_02.drawable], ebx
    mov    [putImage_s03_03.drawable], ecx
    mov    [putImage_s03_04.drawable], edx
    mov    [putImage_s03_05.drawable], esi

    mov    eax, [mainWindow.s04_01_pid]
    mov    ebx, [mainWindow.s04_02_pid]
    mov    ecx, [mainWindow.s04_03_pid]
    mov    edx, [mainWindow.s04_04_pid]
    mov    esi, [mainWindow.s04_05_pid]
    mov    [putImage_s04_01.drawable], eax
    mov    [putImage_s04_02.drawable], ebx
    mov    [putImage_s04_03.drawable], ecx
    mov    [putImage_s04_04.drawable], edx
    mov    [putImage_s04_05.drawable], esi

    mov    eax, [mainWindow.s05_01_pid]
    mov    ebx, [mainWindow.s05_02_pid]
    mov    ecx, [mainWindow.s05_03_pid]
    mov    edx, [mainWindow.s05_04_pid]
    mov    esi, [mainWindow.s05_05_pid]
    mov    [putImage_s05_01.drawable], eax
    mov    [putImage_s05_02.drawable], ebx
    mov    [putImage_s05_03.drawable], ecx
    mov    [putImage_s05_04.drawable], edx
    mov    [putImage_s05_05.drawable], esi

    mov    eax, [mainWindow.cid]
    mov    [putImage_s01_01.gc], eax
    mov    [putImage_s01_02.gc], eax
    mov    [putImage_s01_03.gc], eax
    mov    [putImage_s01_04.gc], eax
    mov    [putImage_s01_05.gc], eax

    mov    [putImage_s02_01.gc], eax
    mov    [putImage_s02_02.gc], eax
    mov    [putImage_s02_03.gc], eax
    mov    [putImage_s02_04.gc], eax
    mov    [putImage_s02_05.gc], eax

    mov    [putImage_s03_01.gc], eax
    mov    [putImage_s03_02.gc], eax
    mov    [putImage_s03_03.gc], eax
    mov    [putImage_s03_04.gc], eax
    mov    [putImage_s03_05.gc], eax

    mov    [putImage_s04_01.gc], eax
    mov    [putImage_s04_02.gc], eax
    mov    [putImage_s04_03.gc], eax
    mov    [putImage_s04_04.gc], eax
    mov    [putImage_s04_05.gc], eax

    mov    [putImage_s05_01.gc], eax
    mov    [putImage_s05_02.gc], eax
    mov    [putImage_s05_03.gc], eax
    mov    [putImage_s05_04.gc], eax
    mov    [putImage_s05_05.gc], eax


;----------------------------------------------------------------------
upload_XImage_s01_01:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s01_01.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s01_01:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s01_01]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s01_01.dstY]
    add    eax, 10
    mov    [putImage_s01_01.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s01_01

endloop_upload_XImage_s01_01:


;----------------------------------------------------------------------
upload_XImage_s01_02:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s01_02.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s01_02:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s01_02]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s01_02.dstY]
    add    eax, 10
    mov    [putImage_s01_02.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s01_02

endloop_upload_XImage_s01_02:


;----------------------------------------------------------------------
upload_XImage_s01_03:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s01_03.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s01_03:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s01_03]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s01_03.dstY]
    add    eax, 10
    mov    [putImage_s01_03.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s01_03

endloop_upload_XImage_s01_03:


;----------------------------------------------------------------------
upload_XImage_s01_04:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s01_04.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s01_04:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s01_04]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s01_04.dstY]
    add    eax, 10
    mov    [putImage_s01_04.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s01_04

endloop_upload_XImage_s01_04:


;----------------------------------------------------------------------
upload_XImage_s01_05:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s01_05.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s01_05:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s01_05]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s01_05.dstY]
    add    eax, 10
    mov    [putImage_s01_05.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s01_05

endloop_upload_XImage_s01_05:


;----------------------------------------------------------------------
upload_XImage_s02_01:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s02_01.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s02_01:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s02_01]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s02_01.dstY]
    add    eax, 10
    mov    [putImage_s02_01.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s02_01

endloop_upload_XImage_s02_01:


;----------------------------------------------------------------------
upload_XImage_s02_02:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s02_02.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s02_02:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s02_02]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s02_02.dstY]
    add    eax, 10
    mov    [putImage_s02_02.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s02_02

endloop_upload_XImage_s02_02:


;----------------------------------------------------------------------
upload_XImage_s02_03:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s02_03.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s02_03:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s02_03]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s02_03.dstY]
    add    eax, 10
    mov    [putImage_s02_03.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s02_03

endloop_upload_XImage_s02_03:


;----------------------------------------------------------------------
upload_XImage_s02_04:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s02_04.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s02_04:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s02_04]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s02_04.dstY]
    add    eax, 10
    mov    [putImage_s02_04.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s02_04

endloop_upload_XImage_s02_04:


;----------------------------------------------------------------------
upload_XImage_s02_05:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s02_05.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s02_05:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s02_05]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s02_05.dstY]
    add    eax, 10
    mov    [putImage_s02_05.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s02_05

endloop_upload_XImage_s02_05:


;----------------------------------------------------------------------
upload_XImage_s03_01:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s03_01.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s03_01:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s03_01]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s03_01.dstY]
    add    eax, 10
    mov    [putImage_s03_01.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s03_01

endloop_upload_XImage_s03_01:


;----------------------------------------------------------------------
upload_XImage_s03_02:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s03_02.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s03_02:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s03_02]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s03_02.dstY]
    add    eax, 10
    mov    [putImage_s03_02.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s03_02

endloop_upload_XImage_s03_02:


;----------------------------------------------------------------------
upload_XImage_s03_03:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s03_03.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s03_03:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s03_03]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s03_03.dstY]
    add    eax, 10
    mov    [putImage_s03_03.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s03_03

endloop_upload_XImage_s03_03:


;----------------------------------------------------------------------
upload_XImage_s03_04:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s03_04.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s03_04:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s03_04]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s03_04.dstY]
    add    eax, 10
    mov    [putImage_s03_04.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s03_04

endloop_upload_XImage_s03_04:


;----------------------------------------------------------------------
upload_XImage_s03_05:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s03_05.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s03_05:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s03_05]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s03_05.dstY]
    add    eax, 10
    mov    [putImage_s03_05.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s03_05

endloop_upload_XImage_s03_05:


;----------------------------------------------------------------------
upload_XImage_s04_01:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s04_01.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s04_01:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s04_01]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s04_01.dstY]
    add    eax, 10
    mov    [putImage_s04_01.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s04_01

endloop_upload_XImage_s04_01:


;----------------------------------------------------------------------
upload_XImage_s04_02:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s04_02.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s04_02:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s04_02]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s04_02.dstY]
    add    eax, 10
    mov    [putImage_s04_02.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s04_02

endloop_upload_XImage_s04_02:


;----------------------------------------------------------------------
upload_XImage_s04_03:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s04_03.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s04_03:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s04_03]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s04_03.dstY]
    add    eax, 10
    mov    [putImage_s04_03.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s04_03

endloop_upload_XImage_s04_03:


;----------------------------------------------------------------------
upload_XImage_s04_04:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s04_04.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s04_04:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s04_04]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s04_04.dstY]
    add    eax, 10
    mov    [putImage_s04_04.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s04_04

endloop_upload_XImage_s04_04:


;----------------------------------------------------------------------
upload_XImage_s04_05:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s04_05.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s04_05:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s04_05]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s04_05.dstY]
    add    eax, 10
    mov    [putImage_s04_05.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s04_05

endloop_upload_XImage_s04_05:


;----------------------------------------------------------------------
upload_XImage_s05_01:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s05_01.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s05_01:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s05_01]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s05_01.dstY]
    add    eax, 10
    mov    [putImage_s05_01.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s05_01

endloop_upload_XImage_s05_01:


;----------------------------------------------------------------------
upload_XImage_s05_02:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s05_02.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s05_02:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s05_02]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s05_02.dstY]
    add    eax, 10
    mov    [putImage_s05_02.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s05_02

endloop_upload_XImage_s05_02:


;----------------------------------------------------------------------
upload_XImage_s05_03:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s05_03.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s05_03:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s05_03]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s05_03.dstY]
    add    eax, 10
    mov    [putImage_s05_03.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s05_03

endloop_upload_XImage_s05_03:


;----------------------------------------------------------------------
upload_XImage_s05_04:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s05_04.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s05_04:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s05_04]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s05_04.dstY]
    add    eax, 10
    mov    [putImage_s05_04.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s05_04

endloop_upload_XImage_s05_04:


;----------------------------------------------------------------------
upload_XImage_s05_05:

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    lea    edi, [XImage_s05_05.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage_s05_05:

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage_s05_05]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage_s05_05.dstY]
    add    eax, 10
    mov    [putImage_s05_05.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_

    cmp    edi, esi
    jbe    loop_upload_XImage_s05_05

endloop_upload_XImage_s05_05:
