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
;   DATE CREATED: 05-FEB-2015
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
%include "data_kernel.inc"
%include "data_strings.inc"
%include "data_XServer.inc"
%include "data_XRequests.inc"
%include "data_XEvent.inc"

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

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
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

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
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

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request CreateWindow
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup mainWindow structure
    mov    eax, [XServer.ridBase]
    mov    ebx, [XScreen.root]
    mov    ecx, [XScreen.blackPixel]
    mov    edx, [XScreen.whitePixel]
    mov    [mainWindow.wid], eax
    mov    [mainWindow.parent], ebx
    mov    [mainWindow.backgroundPixel], ecx
    mov    [mainWindow.borderPixel], edx

; WRITE( socketX, @mainWindow, mainWindow_size )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [mainWindow]
    mov    edx, [mainWindow_size]
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

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    xor    eax, eax
    mov    ax, [poll.revents]
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
;   Wait for the socketX to become ready for writing
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    [poll.fd], eax
    mov    dword [poll.events], _POLLOUT_

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request WM_DELETE_WINDOW atom message
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( socketX, @getWMDeleteMessage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [getWMDeleteMessage]
    mov    edx, 24
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the socketX to become ready for reading
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLIN_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( [poll.fd, poll.events], 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the requested atom message
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @InternAtom_reply, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [InternAtom_reply]
    mov    edx, 32
    int    0x80

    mov    eax, [InternAtom_reply.atom]
    mov    [WMDeleteMessage], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the socketX to become ready for writing
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( [poll.fd, poll.events], 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request ChangeProperty, to modify the mainWindow protocol,
;   and window manager properties
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, [mainWindow.wid]
    mov    ebx, [WMDeleteMessage]
; Setup setWindowDeleteMsg structure
    mov    [setWindowDeleteMsg.window], eax
    mov    [setWindowDeleteMsg.data], ebx
; Setup setWindowName structure
    mov    [setWindowName.window], eax
; Setup setWindowSizeHints structure
    mov    [setWindowSizeHints.window], eax
; Setup setWindowManagerHints
    mov    [setWindowManagerHints.window], eax

; WRITE( socketX, @setWindowDeleteMsg, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowDeleteMsg]
    mov    edx, 28 ;setWindowDeleteMsg.requestLength * 4
    int    0x80
; WRITE( socketX, @setWindowName, 44 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowName]
    mov    edx, 44 ;setWindowName.requestLength * 4
    int    0x80
; WRITE( socketX, @setWindowSizeHints, 96 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowSizeHints]
    mov    edx, 96 ;setWindowSizeHints.requestLength * 4
    int    0x80
; WRITE( socketX, @setWindowManagerHints, 60 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowManagerHints]
    mov    edx, 60
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Requst map mainWindow
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

; WRITE( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    xor    eax, eax
    mov    ax, [poll.revents]
    mov    ebx, _POLLIN_
    cmp    eax, ebx
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




mainloop:




;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for XEvents from the socketX
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLIN_
    mov    [poll.fd], eax
    mov    [poll.events], ebx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check the type of Xevent received
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEventReply, 1 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEventReply]
    mov    edx, 1
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Process the Xevent received
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    esi, [XEventReply.code]


    cmp    esi, _KeyPress_
    jne    not_KeyPress
is_KeyPress:
    jmp    XEventFunc_KeyPress
not_KeyPress:


    cmp    esi, _KeyRelease_
    jne    not_KeyRelease
is_KeyRelease:
    jmp    XEventFunc_KeyRelease
not_KeyRelease:


    cmp    esi, _ButtonPress_
    jne    not_ButtonPress
is_ButtonPress:
    jmp    XEventFunc_ButtonPress
not_ButtonPress:


    cmp    esi, _ButtonRelease_
    jne    not_ButtonRelease
is_ButtonRelease:
    jmp    XEventFunc_ButtonRelease
not_ButtonRelease:


    cmp    esi, _MotionNotify_
    jne    not_MotionNotify
is_MotionNotify:
    jmp    XEventFunc_MotionNotify
not_MotionNotify:


    cmp    esi, _EnterNotify_
    jne    not_EnterNotify
is_EnterNotify:
    jmp    XEventFunc_EnterNotify
not_EnterNotify:


    cmp    esi, _LeaveNotify_
    jne    not_LeaveNotify
is_LeaveNotify:
    jmp    XEventFunc_LeaveNotify
not_LeaveNotify:


    cmp    esi, _FocusIn_
    jne    not_FocusIn
is_FocusIn:
    jmp    XEventFunc_FocusIn
not_FocusIn:


    cmp    esi, _FocusOut_
    jne    not_FocusOut
is_FocusOut:
    jmp    XEventFunc_FocusOut
not_FocusOut:


    cmp    esi, _KeymapNotify_
    jne    not_KeymapNotify
is_KeymapNotify:
    jmp    XEventFunc_KeymapNotify
not_KeymapNotify:


    cmp    esi, _Expose_
    jne    not_Expose
is_Expose:
    jmp    XEventFunc_Expose
not_Expose:


    cmp    esi, _GraphicsExposure_
    jne    not_GraphicsExposure
is_GraphicsExposure:
    jmp    XEventFunc_GraphicsExposure
not_GraphicsExposure:


    cmp    esi, _NoExposure_
    jne    not_NoExposure
is_NoExposure:
    jmp    XEventFunc_NoExposure
not_NoExposure:


    cmp    esi, _VisibilityNotify_
    jne    not_VisibilityNotify
is_VisibilityNotify:
    jmp    XEventFunc_VisibilityNotify
not_VisibilityNotify:


    cmp    esi, _CreateNotify_
    jne    not_CreateNotify
is_CreateNotify:
    jmp    XEventFunc_CreateNotify
not_CreateNotify:


    cmp    esi, _DestroyNotify_
    jne    not_DestroyNotify
is_DestroyNotify:
    jmp    XEventFunc_DestroyNotify
not_DestroyNotify:


    cmp    esi, _UnmapNotify_
    jne    not_UnmapNotify
is_UnmapNotify:
    jmp    XEventFunc_UnmapNotify
not_UnmapNotify:


    cmp    esi, _MapNotify_
    jne    not_MapNotify
is_MapNotify:
    jmp    XEventFunc_MapNotify
not_MapNotify:


    cmp    esi, _MapRequest_
    jne    not_MapRequest
is_MapRequest:
    jmp    XEventFunc_MapRequest
not_MapRequest:


    cmp    esi, _ReparentNotify_
    jne    not_ReparentNotify
is_ReparentNotify:
    jmp    XEventFunc_ReparentNotify
not_ReparentNotify:


    cmp    esi, _ConfigureNotify_
    jne    not_ConfigureNotify
is_ConfigureNotify:
    jmp    XEventFunc_ConfigureNotify
not_ConfigureNotify:


    cmp    esi, _ConfigureRequest_
    jne    not_ConfigureRequest
is_ConfigureRequest:
    jmp    XEventFunc_ConfigureRequest
not_ConfigureRequest:


    cmp    esi, _GravityNotify_
    jne    not_GravityNotify
is_GravityNotify:
    jmp    XEventFunc_GravityNotify
not_GravityNotify:


    cmp    esi, _ResizeRequest_
    jne    not_ResizeRequest
is_ResizeRequest:
    jmp    XEventFunc_ResizeRequest
not_ResizeRequest:


    cmp    esi, _CirculateNotify_
    jne    not_CirculateNotify
is_CirculateNotify:
    jmp    XEventFunc_CirculateNotify
not_CirculateNotify:


    cmp    esi, _CirculateRequest_
    jne    not_CirculateRequest
is_CirculateRequest:
    jmp    XEventFunc_CirculateRequest
not_CirculateRequest:


    cmp    esi, _PropertyNotify_
    jne    not_PropertyNotify
is_PropertyNotify:
    jmp    XEventFunc_PropertyNotify
not_PropertyNotify:


    cmp    esi, _SelectionClear_
    jne    not_SelectionClear
is_SelectionClear:
    jmp    XEventFunc_SelectionClear
not_SelectionClear:


    cmp    esi, _SelectionRequest_
    jne    not_SelectionRequest
is_SelectionRequest:
    jmp    XEventFunc_SelectionRequest
not_SelectionRequest:


    cmp    esi, _SelectionNotify_
    jne    not_SelectionNotify
is_SelectionNotify:
    jmp    XEventFunc_SelectionNotify
not_SelectionNotify:


    cmp    esi, _ColormapNotify_
    jne    not_ColormapNotify
is_ColormapNotify:
    jmp    XEventFunc_ColormapNotify
not_ColormapNotify:


    cmp    esi, _MappingNotify_
    jne    not_MappingNotify
is_MappingNotify:
    jmp    XEventFunc_MappingNotify
not_MappingNotify:


; Unknown events are treated as ClientMessage in this program.
is_ClientMessage:
    jmp    XEventFunc_ClientMessage
not_ClientMessage:




mainloop_end:




;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Exit the program
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_success:
; SOCKETCALL( _CALL_SHUTDOWN_, @[socketX, _SHUT_RDWR_] )
    mov    eax, [socketX]
    mov    ebx, _SHUT_RDWR_
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _CALL_SHUTDOWN_
    lea    ecx, [args]
    int    0x80
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




; ####################################################################
;
;
;
;                          XEvent Functions
;
;
;
; ####################################################################




XEventFunc_KeyPress:
; ************************************************ KeyPress Event ****
; READ( socketX, ESI, 31 ) 
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_KeyPress]
    mov    edx, 31
    int    0x80 
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_KeyPress]
    mov    edx, [evtmsg_len]
    int    0x80 
    jmp    mainloop


XEventFunc_KeyRelease:
; ********************************************** KeyRelease Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_KeyRelease]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_KeyRelease]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_ButtonPress:
; ********************************************* ButtonPress Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ButtonPress]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ButtonPress]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_ButtonRelease:
; ******************************************* ButtonRelease Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ButtonRelease]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ButtonRelease]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_MotionNotify:
; ******************************************** MotionNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_MotionNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_MotionNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_EnterNotify:
; ********************************************* EnterNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_EnterNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_EnterNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_LeaveNotify:
; ********************************************* LeaveNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_LeaveNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_LeaveNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_FocusIn:
; READ( socketX, ESI, 31 ) 
; ************************************************* FocusIn Event ****
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_FocusIn]
    mov    edx, 31
    int    0x80 
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_FocusIn]
    mov    edx, [evtmsg_len]
    int    0x80 
    jmp    mainloop


XEventFunc_FocusOut:
; ************************************************ FocusOut Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_FocusOut]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_FocusOut]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_KeymapNotify:
; ******************************************** KeymapNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_KeymapNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_KeymapNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_Expose:
; ************************************************** Expose Event ****
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
    jmp    mainloop


XEventFunc_GraphicsExposure:
; **************************************** GraphicsExposure Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_GraphicsExposure]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_GraphicsExposure]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_NoExposure:
; ********************************************** NoExposure Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_NoExposure]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_NoExposure]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_VisibilityNotify:
; **************************************** VisibilityNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_VisibilityNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_VisibilityNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_CreateNotify:
; ******************************************** CreateNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_CreateNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_CreateNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


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


XEventFunc_UnmapNotify:
; ********************************************* UnmapNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_UnmapNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_UnmapNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_MapNotify:
; *********************************************** MapNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_MapNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_MapNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_MapRequest:
; ********************************************** MapRequest Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_MapRequest]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_MapRequest]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_ReparentNotify:
; ****************************************** ReparentNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ReparentNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ReparentNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_ConfigureNotify:
; ***************************************** ConfigureNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ConfigureNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ConfigureNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_ConfigureRequest:
; **************************************** ConfigureRequest Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ConfigureRequest]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ConfigureRequest]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_GravityNotify:
; ******************************************* GravityNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_GravityNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_GravityNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_ResizeRequest:
; ******************************************* ResizeRequest Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ResizeRequest]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ResizeRequest]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_CirculateNotify:
; ***************************************** CirculateNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_CirculateNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_CirculateNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_CirculateRequest:
; **************************************** CirculateRequest Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_CirculateRequest]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_CirculateRequest]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_PropertyNotify:
; ****************************************** PropertyNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_PropertyNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_PropertyNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_SelectionClear:
; ****************************************** SelectionClear Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_SelectionClear]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_SelectionClear]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_SelectionRequest:
; **************************************** SelectionRequest Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_SelectionRequest]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_SelectionRequest]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_SelectionNotify:
; ***************************************** SelectionNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_SelectionNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_SelectionNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_ColormapNotify:
; ****************************************** ColormapNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_ColormapNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_ColormapNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


XEventFunc_MappingNotify:
; ******************************************* MappingNotify Event ****
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_MappingNotify]
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_MappingNotify]
    mov    edx, [evtmsg_len]
    int    0x80
    jmp    mainloop


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
