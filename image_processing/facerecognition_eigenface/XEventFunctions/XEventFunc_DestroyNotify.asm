;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_DestroyNotify.asm
;
; This source file contains function XEventFunc_DestroyNotify().
; The function only executed when the program received DestroyNotify
; event.
;
; Function XEventFunc_DestroyNotify( void ) : void
;
;=====================================================================

section .text


XEventFunc_DestroyNotify:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received DestroyNotify event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_DestroyNotify, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_DestroyNotify]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_DestroyNotify structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_DestroyNotify, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_DestroyNotify]
    mov    edx, 31
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If the DestroyNotify report is received from the mainWindow,
;   exit the mainloop.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, [XEvent_DestroyNotify.window]
    mov    ebx, [winTrainingImages.wid]
    cmp    eax, ebx
    jne    mainWindow_isnt_destroyed

mainWindow_is_destroyed:

    jmp mainloop_end

mainWindow_isnt_destroyed:

    jmp mainloop
