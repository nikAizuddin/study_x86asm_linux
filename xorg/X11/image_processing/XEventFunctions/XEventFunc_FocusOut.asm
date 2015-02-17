;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_FocusOut.asm
;
; This source file contains function XEventFunc_FocusOut().
; The function only executed when the program received FocusOut
; event.
;
; Function XEventFunc_FocusOut( void ) : void
;
;=====================================================================

section .text


XEventFunc_FocusOut:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received FocusOut event.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_FocusOut, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_FocusOut]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_FocusOut structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_FocusOut, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_FocusOut]
    mov    edx, 31
    int    0x80

    jmp    mainloop
