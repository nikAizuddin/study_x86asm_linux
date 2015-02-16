;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_EnterNotify.asm
;
; This source file contains function XEventFunc_EnterNotify().
; The function only executed when the program received EnterNotify
; event.
;
; Function XEventFunc_EnterNotify( void ) : void
;
;=====================================================================

section .text


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received EnterNotify event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_EnterNotify, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_EnterNotify]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_EnterNotify structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

XEventFunc_EnterNotify:

; READ( socketX, @XEvent_EnterNotify, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_EnterNotify]
    mov    edx, 31
    int    0x80

    jmp    mainloop
