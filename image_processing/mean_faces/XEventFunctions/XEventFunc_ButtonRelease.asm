;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_ButtonRelease.asm
;
; This source file contains function XEventFunc_ButtonRelease().
; The function only executed when the program received ButtonRelease
; event.
;
; Function XEventFunc_ButtonRelease( void ) : void
;
;=====================================================================

section .text

XEventFunc_ButtonRelease:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received ButtonRelease event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_ButtonRelease, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ButtonRelease]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_ButtonRelease structure.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_ButtonRelease, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ButtonRelease]
    mov    edx, 31
    int    0x80

    jmp    mainloop
