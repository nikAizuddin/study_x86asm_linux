;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_ColormapNotify.asm
;
; This source file contains function XEventFunc_ColormapNotify().
; The function only executed when the program received
; ColormapNotify event.
;
; Function XEventFunc_ColormapNotify( void ) : void
;
;=====================================================================

section .text


XEventFunc_ColormapNotify:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received ColormapNotify event.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_ColormapNotify, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ColormapNotify]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_ColormapNotify structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_ColormapNotify, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ColormapNotify]
    mov    edx, 31
    int    0x80

    jmp    mainloop
