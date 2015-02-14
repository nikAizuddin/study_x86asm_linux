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

XEventFunc_ClientMessage:
; ******************************************* ClientMessage Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ClientMessage]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ClientMessage]
    mov    edx, [evtmsg_len]
    int    0x80
; Exit mainloop if XEvent_ClientMessage.data[0] == WMDeleteMessage
    mov    eax, [XEvent_ClientMessage.data]
    mov    ebx, [WMDeleteMessage]
    cmp    eax, ebx
    jne    not_WindowDeleteMessage
received_WindowDeleteMessage:
; Destroy the mainWindow
    mov    eax, [mainWindow.wid]
    mov    [destroyWindow.window], eax
; WRITE( socketX, @DestroyWindow, 8 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [destroyWindow]
    mov    edx, 8
    int    0x80
    jmp    mainloop
not_WindowDeleteMessage:
    jmp    mainloop