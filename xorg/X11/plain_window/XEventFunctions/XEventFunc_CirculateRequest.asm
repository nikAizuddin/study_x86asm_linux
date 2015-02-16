;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_CirculateRequest.asm
;
; This source file contains function XEventFunc_CirculateRequest().
; The function only executed when the program received
; CirculateRequest event.
;
; Function XEventFunc_CirculateRequest( void ) : void
;
;=====================================================================

section .text

XEventFunc_CirculateRequest:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received CirculateRequest event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_CirculateRequest, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_CirculateRequest]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_CirculateRequest structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_CirculateRequest, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_CirculateRequest]
    mov    edx, 31
    int    0x80

    jmp    mainloop
