;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_PropertyNotify.asm
;
; This source file contains function XEventFunc_PropertyNotify().
; The function only executed when the program received
; PropertyNotify event.
;
; Function XEventFunc_PropertyNotify( void ) : void
;
;=====================================================================

section .text


XEventFunc_PropertyNotify:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received PropertyNotify event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_PropertyNotify, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_PropertyNotify]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_PropertyNotify structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_PropertyNotify, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_PropertyNotify]
    mov    edx, 31
    int    0x80

    jmp    mainloop
