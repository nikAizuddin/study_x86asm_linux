;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_ClientMessage.asm
;
; This source file contains function XEventFunc_ClientMessage().
; The function only executed when the program received other
; events.
;
; Function XEventFunc_ClientMessage( void ) : void
;
;=====================================================================

section .text


XEventFunc_ClientMessage:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received ClientMessage event.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_ClientMessage, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ClientMessage]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_ClientMessage structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_ClientMessage, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ClientMessage]
    mov    edx, 31
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Exit mainloop if XEvent_ClientMessage.data[0] == WMDeleteMessage
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, [XEvent_ClientMessage.data]
    mov    ebx, [WMDeleteMessage]
    cmp    eax, ebx
    jne    not_WindowDeleteMessage

received_WindowDeleteMessage:

; Destroy the mainWindow
    mov    eax, [mainWindow.wid]
    mov    [destroyWindow.window], eax
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [destroyWindow]
    mov    edx, 8
    int    0x80

not_WindowDeleteMessage:
    jmp    mainloop
