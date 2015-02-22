;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_GraphicsExposure.asm
;
; This source file contains function XEventFunc_GraphicsExposure().
; The function only executed when the program received
; GraphicsExposure event.
;
; Function XEventFunc_GraphicsExposure( void ) : void
;
;=====================================================================

section .text


XEventFunc_GraphicsExposure:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user the the program received GraphicsExposure event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_GraphicsExposure, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_GraphicsExposure]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_GraphicsExposure structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_GraphicsExposure, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_GraphicsExposure]
    mov    edx, 31
    int    0x80

    jmp    mainloop
