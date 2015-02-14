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

XEventFunc_DestroyNotify:
; ******************************************* DestroyNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_DestroyNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_DestroyNotify]
    mov    edx, [evtmsg_len]
    int    0x80
; If the DestroyNotify report is received from the mainWindow, exit
    mov    eax, [XEvent_DestroyNotify.window]
    mov    ebx, [mainWindow.wid]
    cmp    eax, ebx
    jne    mainWindow_isnt_destroyed
mainWindow_is_destroyed:
    jmp    mainloop_end
mainWindow_isnt_destroyed:
    jmp    mainloop
