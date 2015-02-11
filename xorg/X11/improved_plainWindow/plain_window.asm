;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                      Create a plain window
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 11-FEB-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

%include "constants.inc"
%include "data.inc"

global _start

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create socket
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall socket
    mov    dword [args.param1], _PF_LOCAL_    ;protocol family
    mov    dword [args.param2], _SOCK_STREAM_ ;socket type
    mov    dword [args.param3], _IPPROTO_IP_  ;protocol used

; SOCKETCALL( _CALL_SOCKET_, @args )
    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _CALL_SOCKET_
    lea    ecx, [args]
    int    0x80

    test   eax, eax
    js     socket_create_fail
    jmp    socket_create_success

socket_create_fail:
    jmp    exit_failure
socket_create_success:
    mov    [socketX], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Connect to X Server
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall connect
    mov    eax, [socketX]
    lea    ebx, [contactX]
    mov    ecx, [contactX_len]
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    [args.param3], ecx

; SOCKETCALL( _CALL_CONNECT_, @args )
    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _CALL_CONNECT_
    lea    ecx, [args]
    int    0x80

    test   eax, eax
    js     socket_connect_fail
    jmp    socket_connect_success

socket_connect_fail:
    jmp    exit_failure
socket_connect_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set socketX non-blocking
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; FCNTL64( socketX, _F_SETFL_, _O_RDWR_ | _O_NONBLOCK_ )
    mov    eax, _SYSCALL_FCNTL64_
    mov    ebx, [socketX]
    mov    ecx, _F_SETFL_
    lea    edx, [_O_RDWR_ + _O_NONBLOCK_]
    int    0x80

    test   eax, eax
    js     fcntl64_setflag_fail
    jmp    fcntl64_setflag_success

fcntl64_setflag_fail:
    jmp    exit_failure
fcntl64_setflag_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the socketX to become ready for writing
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for systemcall poll
    mov    eax, [socketX]
    mov    [poll.fd], eax
    mov    word [poll.events], _POLLOUT_

; POLL( @poll, 1, _POLL_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Authenticate our connection to the X Server
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( socketX, @authenticateX, authenticateX_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [authenticateX]
    mov    edx, [authenticateX_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the socketX to become ready for reading
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    [poll.fd], eax
    mov    word [poll.events], _POLLIN_

; POLL( @poll, 1, _POLL_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the first 2 bytes of data, to check
;   whether the authentication is success or fail
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @authenticateStatus, 2 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [authenticateStatus]
    mov    edx, 2
    int    0x80

    test   eax, eax
    js     get_authstatus_fail
    jmp    get_authstatus_success

get_authstatus_fail:
    jmp   exit_failure
get_authstatus_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check our authentication status.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    xor    eax, eax
    mov    al, [authenticateStatus]
    cmp    eax, 1
    jne    auth_status_fail
    jmp    auth_status_success

auth_status_fail:
    jmp    exit_failure
auth_status_success:
; READ( socketX, @authenticateSuccess, 6 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [authenticateSuccess]
    mov    edx, 6
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the additional data
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @additionalData, authenticateSuccess.lenAddData*4 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [additionalData]
    mov    edx, [authenticateSuccess.lenAddData]
    lea    edx, [edx * 4]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Extract useful values from the additional data
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [additionalData]

; Fill additional data in our XServer data structure
    lea    edi, [XServer]
    movsd  ;get release number
    movsd  ;get base resource id
    movsd  ;get resource id mask
    movsd  ;get motion buffer size
    movsw  ;get length of vendor name
    movsw  ;get max request length
    movsb  ;get number of roots
    movsb  ;get number of formats
    movsb  ;get image byte order
    movsb  ;get bitmap bit order
    movsb  ;get bitmap scanline unit
    movsb  ;get bitmap scanline pad
    movsb  ;get minimum key code
    movsb  ;get maximum key code
    movsd  ;unused

; Get vendor name and fill into XServer.vendorStr
    xor    eax, eax
    xor    edx, edx
    mov    ebx, 4
    mov    ax, [XServer.nbytesVendor]
    div    ebx
    shr    edx, 1
    add    eax, edx
    mov    ecx, eax
    rep    movsd

; Get screen structure from the additional data
    mov    eax, [XServer.numFormats]
    mov    ebx, 8
    xor    edx, edx
    mul    ebx
    add    esi, eax
    lea    edi, [XScreen]
    movsd  ;get root window id
    movsd  ;get default colormap
    movsd  ;get white pixel value
    movsd  ;get black pixel value
    movsd  ;get current event input mask
    movsw  ;get screen resolution width in pixel
    movsw  ;get screen resolution height in pixel
    movsw  ;get screen resolution width in millimeters
    movsw  ;get screen resolution height in millimeters
    movsw  ;get minimum installed maps
    movsw  ;get maximum installed maps
    movsd  ;get root visual id
    movsb  ;get backing store value
    movsb  ;get save unders flag
    movsb  ;get root depth
    movsb  ;get number of depths


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the socket to become ready for writing
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    [poll.fd], eax
    mov    dword [poll.events], _POLLOUT_

; POLL( @poll, 1, _POLL_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request CreateWindow
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup mainWindow structure
    mov    eax, [XScreen.root]
    mov    ebx, [XServer.ridBase]
    mov    [mainWindow.wid], ebx
    mov    [mainWindow.parent], eax

; WRITE( socketX, @mainWindow, 32 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [mainWindow]
    mov    edx, 32
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check createWindow requests. If the request is
;   fail, the server will complain. Otherwise, the
;   server will just keep quiet.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    lea    ebx, [_POLLIN_ + _POLLOUT_]
    mov    [poll.fd], eax
    mov    [poll.events], ebx

; POLL( @poll, 1, _POLL_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_TIMEOUT_
    int    0x80

    mov    eax, [poll.revents]
    mov    ebx, _POLLIN_
    cmp    eax, ebx
    je     createWindow_fail
    jmp    createWindow_success

createWindow_fail:
; READ( socketX, @requestStatus, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [requestStatus]
    mov    edx, 32
    int    0x80
    jmp    exit_failure
createWindow_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the socket to become ready for writing
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    [poll.fd], eax
    mov    dword [poll.events], _POLLOUT_

; POLL( @poll, 1, _POLL_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Requst map the mainWindow
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup mapWindow structure
    mov    eax, [mainWindow.wid]
    mov    [mapWindow.wid], eax

; WRITE( socketX, @mapWindow, 8 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [mapWindow]
    mov    edx, 8
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if mapWindow request failed.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    lea    ebx, [_POLLIN_ + _POLLOUT_]
    mov    [poll.fd], eax
    mov    [poll.events], ebx

; WRITE( @poll, 1, _POLL_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_TIMEOUT_
    int    0x80

    mov    eax, [poll.revents]
    mov    ebx, _POLLIN_
    je     mapWindow_fail
    jmp    mapWindow_success

mapWindow_fail:
; READ( socketX, @requestStatus, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [requestStatus]
    mov    edx, 32
    int    0x80
    jmp    exit_failure
mapWindow_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for 5 seconds
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    [poll.fd], eax
    mov    dword [poll.events], _POLLIN_

; POLL( @poll, 1, 5000 )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, 5000  ;5000 milliseconds = 5 seconds
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Exit the program
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_success:
; CLOSE( socketX )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socketX]
    int    0x80
; EXIT( 0 )
    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx
    int    0x80

exit_failure:
; CLOSE( socketX )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socketX]
    int    0x80
; EXIT( -1 )
    mov    eax, _SYSCALL_EXIT_
    mov    ebx, -1
    int    0x80
