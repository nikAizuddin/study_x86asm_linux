;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_SelectionRequest.asm
;
; This source file contains function XEventFunc_SelectionRequest().
; The function only executed when the program received
; SelectionRequest event.
;
; Function XEventFunc_SelectionRequest( void ) : void
;
;=====================================================================

section .text


XEventFunc_SelectionRequest:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received SelectionRequest event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_SelectionRequest, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_SelectionRequest]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_SelectionRequest structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_SelectionRequest, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_SelectionRequest]
    mov    edx, 31
    int    0x80

    jmp    mainloop
