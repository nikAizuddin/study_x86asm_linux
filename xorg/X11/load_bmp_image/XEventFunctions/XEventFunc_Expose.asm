;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_Expose.asm
;
; This source file contains function XEventFunc_Expose().
; The function only executed when the program received Expose
; event.
;
; Function XEventFunc_Expose( void ) : void
;
;=====================================================================

section .text


XEventFunc_Expose:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received Expose event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_Expose, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_Expose]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_Expose structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_Expose, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_Expose]
    mov    edx, 31
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure X Server is ready to receive request, because this
;   program perform mainloop faster than X Server.
;   Waiting for some milliseconds before sending request is needed
;   to prevent overflow from X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], ebx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Draw/Redraw the testimage by using CopyArea request.
;   Using CopyArea request to draw image is much more efficient
;   compared to PutImage request. The PutImage request should only
;   be used to put data pixel onto pixmap, and then use CopyArea
;   request to copy the picture from pixmap to the main window.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( socketX, @copyArea 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea]
    mov    edx, 28
    int    0x80

    jmp    mainloop
