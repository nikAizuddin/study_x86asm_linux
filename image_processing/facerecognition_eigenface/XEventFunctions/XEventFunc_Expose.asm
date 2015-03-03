;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_Expose.asm
;
; This source file contains function XEventFunc_Expose().
; The function only executed when the program received Expose
; event.
;
; Function XEventFunc_Expose( void ) : void
;
;=====================================================================

section .text


XEventFunc_Expose:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received Expose event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_Expose, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_Expose]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_Expose structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_Expose, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_Expose]
    mov    edx, 31
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure X Server is ready to receive request, because this
;   program perform mainloop faster than X Server.
;   Waiting for some milliseconds before sending request is needed
;   to prevent overflow from X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Draw/Redraw the testimage by using CopyArea request.
;   Using CopyArea request to draw image is much more efficient
;   compared to PutImage request. The PutImage request should only
;   be used to put data pixel onto pixmap, and then use CopyArea
;   request to copy the picture from pixmap to the main window.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_01, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_01]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_02, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_02]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;WRITE( socketX, @copyArea_s01_03, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_03]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_04, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_04]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_05, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_05]
    mov    edx, 28
    int    0x80


;---------------------------------------------------------------------

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_01, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_01]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_02, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_02]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;WRITE( socketX, @copyArea_s02_03, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_03]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_04, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_04]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_05, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_05]
    mov    edx, 28
    int    0x80


;---------------------------------------------------------------------

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_01, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_01]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_02, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_02]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;WRITE( socketX, @copyArea_s03_03, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_03]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_04, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_04]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_05, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_05]
    mov    edx, 28
    int    0x80


;---------------------------------------------------------------------

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_01, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_01]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_02, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_02]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;WRITE( socketX, @copyArea_s04_03, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_03]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_04, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_04]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_05, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_05]
    mov    edx, 28
    int    0x80


;---------------------------------------------------------------------

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_01, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_01]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_02, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_02]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;WRITE( socketX, @copyArea_s05_03, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_03]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_04, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_04]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_05, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_05]
    mov    edx, 28
    int    0x80


;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_01_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_01_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_02_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_02_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_03_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_03_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_04_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_04_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s01_05_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s01_05_meanSubtracted]
    mov    edx, 28
    int    0x80

;---------------------------------------------------------------------
; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_01_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_01_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_02_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_02_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_03_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_03_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_04_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_04_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s02_05_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s02_05_meanSubtracted]
    mov    edx, 28
    int    0x80

;---------------------------------------------------------------------
; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_01_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_01_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_02_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_02_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_03_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_03_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_04_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_04_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s03_05_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s03_05_meanSubtracted]
    mov    edx, 28
    int    0x80

;---------------------------------------------------------------------
; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_01_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_01_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_02_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_02_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_03_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_03_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_04_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_04_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s04_05_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s04_05_meanSubtracted]
    mov    edx, 28
    int    0x80

;---------------------------------------------------------------------
; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_01_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_01_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_02_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_02_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_03_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_03_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_04_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_04_meanSubtracted]
    mov    edx, 28
    int    0x80


; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @copyArea_s05_05_meanSubtracted, 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea_s05_05_meanSubtracted]
    mov    edx, 28
    int    0x80

;---------------------------------------------------------------------

    jmp    mainloop
