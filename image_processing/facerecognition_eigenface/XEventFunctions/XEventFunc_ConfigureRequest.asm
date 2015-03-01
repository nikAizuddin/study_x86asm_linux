;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_ConfigureRequest.asm
;
; This source file contains function XEventFunc_ConfigureRequest().
; The function only executed when the program received
; ConfigureRequest event.
;
; Function XEventFunc_ConfigureRequest( void ) : void
;
;=====================================================================

section .text

XEventFunc_ConfigureRequest:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received ConfigureRequest event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_ConfigureRequest, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ConfigureRequest]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_ConfigureRequest structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_ConfigureRequest, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ConfigureRequest]
    mov    edx, 31
    int    0x80

    jmp    mainloop
