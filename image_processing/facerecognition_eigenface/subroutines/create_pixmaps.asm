;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; create_pixmaps.asm
;
;=====================================================================

section .text


create_pixmaps:


;Make sure the X Server is ready to receive the next request.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create winTrainingImages pixmaps
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup createPixmap structures
;We will send these structures as the CreatePixmap request.

    mov    eax, [XServer.ridBase]

    add    eax, 2
    mov    [createPixmap_s01_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s02_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s03_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s04_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s05_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_05.pid], eax

    mov    eax, [winTrainingImages.wid]
    mov    [createPixmap_s01_01.drawable], eax
    mov    [createPixmap_s01_02.drawable], eax
    mov    [createPixmap_s01_03.drawable], eax
    mov    [createPixmap_s01_04.drawable], eax
    mov    [createPixmap_s01_05.drawable], eax

    mov    [createPixmap_s02_01.drawable], eax
    mov    [createPixmap_s02_02.drawable], eax
    mov    [createPixmap_s02_03.drawable], eax
    mov    [createPixmap_s02_04.drawable], eax
    mov    [createPixmap_s02_05.drawable], eax

    mov    [createPixmap_s03_01.drawable], eax
    mov    [createPixmap_s03_02.drawable], eax
    mov    [createPixmap_s03_03.drawable], eax
    mov    [createPixmap_s03_04.drawable], eax
    mov    [createPixmap_s03_05.drawable], eax

    mov    [createPixmap_s04_01.drawable], eax
    mov    [createPixmap_s04_02.drawable], eax
    mov    [createPixmap_s04_03.drawable], eax
    mov    [createPixmap_s04_04.drawable], eax
    mov    [createPixmap_s04_05.drawable], eax

    mov    [createPixmap_s05_01.drawable], eax
    mov    [createPixmap_s05_02.drawable], eax
    mov    [createPixmap_s05_03.drawable], eax
    mov    [createPixmap_s05_04.drawable], eax
    mov    [createPixmap_s05_05.drawable], eax


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s01_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

    mov    eax, [createPixmap_s01_01.pid]
    mov    ebx, [createPixmap_s01_02.pid]
    mov    ecx, [createPixmap_s01_03.pid]
    mov    edx, [createPixmap_s01_04.pid]
    mov    esi, [createPixmap_s01_05.pid]
    mov    [winTrainingImages.s01_01_pid], eax
    mov    [winTrainingImages.s01_02_pid], ebx
    mov    [winTrainingImages.s01_03_pid], ecx
    mov    [winTrainingImages.s01_04_pid], edx
    mov    [winTrainingImages.s01_05_pid], esi

    mov    eax, [createPixmap_s02_01.pid]
    mov    ebx, [createPixmap_s02_02.pid]
    mov    ecx, [createPixmap_s02_03.pid]
    mov    edx, [createPixmap_s02_04.pid]
    mov    esi, [createPixmap_s02_05.pid]
    mov    [winTrainingImages.s02_01_pid], eax
    mov    [winTrainingImages.s02_02_pid], ebx
    mov    [winTrainingImages.s02_03_pid], ecx
    mov    [winTrainingImages.s02_04_pid], edx
    mov    [winTrainingImages.s02_05_pid], esi

    mov    eax, [createPixmap_s03_01.pid]
    mov    ebx, [createPixmap_s03_02.pid]
    mov    ecx, [createPixmap_s03_03.pid]
    mov    edx, [createPixmap_s03_04.pid]
    mov    esi, [createPixmap_s03_05.pid]
    mov    [winTrainingImages.s03_01_pid], eax
    mov    [winTrainingImages.s03_02_pid], ebx
    mov    [winTrainingImages.s03_03_pid], ecx
    mov    [winTrainingImages.s03_04_pid], edx
    mov    [winTrainingImages.s03_05_pid], esi

    mov    eax, [createPixmap_s04_01.pid]
    mov    ebx, [createPixmap_s04_02.pid]
    mov    ecx, [createPixmap_s04_03.pid]
    mov    edx, [createPixmap_s04_04.pid]
    mov    esi, [createPixmap_s04_05.pid]
    mov    [winTrainingImages.s04_01_pid], eax
    mov    [winTrainingImages.s04_02_pid], ebx
    mov    [winTrainingImages.s04_03_pid], ecx
    mov    [winTrainingImages.s04_04_pid], edx
    mov    [winTrainingImages.s04_05_pid], esi

    mov    eax, [createPixmap_s05_01.pid]
    mov    ebx, [createPixmap_s05_02.pid]
    mov    ecx, [createPixmap_s05_03.pid]
    mov    edx, [createPixmap_s05_04.pid]
    mov    esi, [createPixmap_s05_05.pid]
    mov    [winTrainingImages.s05_01_pid], eax
    mov    [winTrainingImages.s05_02_pid], ebx
    mov    [winTrainingImages.s05_03_pid], ecx
    mov    [winTrainingImages.s05_04_pid], edx
    mov    [winTrainingImages.s05_05_pid], esi


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create winMeanSubtracted pixmaps
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup createPixmap structures
;We will send these structures as the CreatePixmap request.

    mov    eax, [XServer.ridBase]

    add    eax, (0x100000 +  2)
    mov    [createPixmap_s01_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s01_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s02_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s02_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s03_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s03_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s04_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s04_05.pid], eax

    add    eax, 1
    mov    [createPixmap_s05_01.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_02.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_03.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_04.pid], eax
    add    eax, 1
    mov    [createPixmap_s05_05.pid], eax

    mov    eax, [winMeanSubtracted.wid]
    mov    [createPixmap_s01_01.drawable], eax
    mov    [createPixmap_s01_02.drawable], eax
    mov    [createPixmap_s01_03.drawable], eax
    mov    [createPixmap_s01_04.drawable], eax
    mov    [createPixmap_s01_05.drawable], eax

    mov    [createPixmap_s02_01.drawable], eax
    mov    [createPixmap_s02_02.drawable], eax
    mov    [createPixmap_s02_03.drawable], eax
    mov    [createPixmap_s02_04.drawable], eax
    mov    [createPixmap_s02_05.drawable], eax

    mov    [createPixmap_s03_01.drawable], eax
    mov    [createPixmap_s03_02.drawable], eax
    mov    [createPixmap_s03_03.drawable], eax
    mov    [createPixmap_s03_04.drawable], eax
    mov    [createPixmap_s03_05.drawable], eax

    mov    [createPixmap_s04_01.drawable], eax
    mov    [createPixmap_s04_02.drawable], eax
    mov    [createPixmap_s04_03.drawable], eax
    mov    [createPixmap_s04_04.drawable], eax
    mov    [createPixmap_s04_05.drawable], eax

    mov    [createPixmap_s05_01.drawable], eax
    mov    [createPixmap_s05_02.drawable], eax
    mov    [createPixmap_s05_03.drawable], eax
    mov    [createPixmap_s05_04.drawable], eax
    mov    [createPixmap_s05_05.drawable], eax


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s01_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @creatPixmap_s01_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s01_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s02_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s02_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s03_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s03_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s04_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s04_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_01, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_01]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_02, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_02]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_03, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_03]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_04, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_04]
    mov    edx, 16
    int    0x80


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @createPixmap_s05_05, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap_s05_05]
    mov    edx, 16
    int    0x80


;---------------------------------------------------------------------


    mov    eax, [createPixmap_s01_01.pid]
    mov    ebx, [createPixmap_s01_02.pid]
    mov    ecx, [createPixmap_s01_03.pid]
    mov    edx, [createPixmap_s01_04.pid]
    mov    esi, [createPixmap_s01_05.pid]
    mov    [winMeanSubtracted.s01_01_pid], eax
    mov    [winMeanSubtracted.s01_02_pid], ebx
    mov    [winMeanSubtracted.s01_03_pid], ecx
    mov    [winMeanSubtracted.s01_04_pid], edx
    mov    [winMeanSubtracted.s01_05_pid], esi

    mov    eax, [createPixmap_s02_01.pid]
    mov    ebx, [createPixmap_s02_02.pid]
    mov    ecx, [createPixmap_s02_03.pid]
    mov    edx, [createPixmap_s02_04.pid]
    mov    esi, [createPixmap_s02_05.pid]
    mov    [winMeanSubtracted.s02_01_pid], eax
    mov    [winMeanSubtracted.s02_02_pid], ebx
    mov    [winMeanSubtracted.s02_03_pid], ecx
    mov    [winMeanSubtracted.s02_04_pid], edx
    mov    [winMeanSubtracted.s02_05_pid], esi

    mov    eax, [createPixmap_s03_01.pid]
    mov    ebx, [createPixmap_s03_02.pid]
    mov    ecx, [createPixmap_s03_03.pid]
    mov    edx, [createPixmap_s03_04.pid]
    mov    esi, [createPixmap_s03_05.pid]
    mov    [winMeanSubtracted.s03_01_pid], eax
    mov    [winMeanSubtracted.s03_02_pid], ebx
    mov    [winMeanSubtracted.s03_03_pid], ecx
    mov    [winMeanSubtracted.s03_04_pid], edx
    mov    [winMeanSubtracted.s03_05_pid], esi

    mov    eax, [createPixmap_s04_01.pid]
    mov    ebx, [createPixmap_s04_02.pid]
    mov    ecx, [createPixmap_s04_03.pid]
    mov    edx, [createPixmap_s04_04.pid]
    mov    esi, [createPixmap_s04_05.pid]
    mov    [winMeanSubtracted.s04_01_pid], eax
    mov    [winMeanSubtracted.s04_02_pid], ebx
    mov    [winMeanSubtracted.s04_03_pid], ecx
    mov    [winMeanSubtracted.s04_04_pid], edx
    mov    [winMeanSubtracted.s04_05_pid], esi

    mov    eax, [createPixmap_s05_01.pid]
    mov    ebx, [createPixmap_s05_02.pid]
    mov    ecx, [createPixmap_s05_03.pid]
    mov    edx, [createPixmap_s05_04.pid]
    mov    esi, [createPixmap_s05_05.pid]
    mov    [winMeanSubtracted.s05_01_pid], eax
    mov    [winMeanSubtracted.s05_02_pid], ebx
    mov    [winMeanSubtracted.s05_03_pid], ecx
    mov    [winMeanSubtracted.s05_04_pid], edx
    mov    [winMeanSubtracted.s05_05_pid], esi
