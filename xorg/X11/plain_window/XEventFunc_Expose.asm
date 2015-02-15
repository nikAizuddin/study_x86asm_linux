;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_kernel.inc
;
; This header file contains structures that are related to
; Linux Kernel systemcalls.
;
;=====================================================================

section .text

XEventFunc_Expose:

; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_Expose]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_Expose]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure X Server is ready to receive request, because this
;   program perform mainloop faster than X Server.
;   Waiting for some milliseconds before sending request is needed
;   to prevent overflow from X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; POLL( {socketX, _POLLOUT_}, 1, _POLL_INFINITE_TIMEOUT_ )
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
;   Copy pixel?
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( socketX, @copyArea 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea]
    mov    edx, 28
    int    0x80

    jmp    mainloop
