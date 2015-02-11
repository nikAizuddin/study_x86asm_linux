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
;   Wait for Xevents from the socketX
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

; If the READ() == 0, exit the mainloop
    test   eax, eax
    jz     mainloop_end


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Process the Xevent received
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [XEventReply.code]


    cmp    eax, _KeyPress_
    jne    not_KeyPress
; ************************************************ KeyPress Event ****
is_KeyPress:
    lea    esi, [XEvent_KeyPress]
    lea    edi, [evtmsg_KeyPress]
    jmp    fill_XEvent_structure
not_KeyPress:


    cmp    eax, _KeyRelease_
    jne    not_KeyRelease
; ********************************************** KeyRelease Event ****
is_KeyRelease:
    lea    esi, [XEvent_KeyRelease]
    lea    edi, [evtmsg_KeyRelease]
    jmp    fill_XEvent_structure
not_KeyRelease:


    cmp    eax, _ButtonPress_
    jne    not_ButtonPress
; ********************************************* ButtonPress Event ****
is_ButtonPress:
    lea    esi, [XEvent_ButtonPress]
    lea    edi, [evtmsg_ButtonPress]
    jmp    fill_XEvent_structure
not_ButtonPress:


    cmp    eax, _ButtonRelease_
    jne    not_ButtonRelease
; ******************************************* ButtonRelease Event ****
is_ButtonRelease:
    lea    esi, [XEvent_ButtonRelease]
    lea    edi, [evtmsg_ButtonRelease]
    jmp    fill_XEvent_structure
not_ButtonRelease:


    cmp    eax, _MotionNotify_
    jne    not_MotionNotify
; ******************************************** MotionNotify Event ****
is_MotionNotify:
    lea    esi, [XEvent_MotionNotify]
    lea    edi, [evtmsg_MotionNotify]
    jmp    fill_XEvent_structure
not_MotionNotify:


    cmp    eax, _EnterNotify_
    jne    not_EnterNotify
; ********************************************* EnterNotify Event ****
is_EnterNotify:
    lea    esi, [XEvent_EnterNotify]
    lea    edi, [evtmsg_EnterNotify]
    jmp    fill_XEvent_structure
not_EnterNotify:


    cmp    eax, _LeaveNotify_
    jne    not_LeaveNotify
; ********************************************* LeaveNotify Event ****
is_LeaveNotify:
    lea    esi, [XEvent_LeaveNotify]
    lea    edi, [evtmsg_LeaveNotify]
    jmp    fill_XEvent_structure
not_LeaveNotify:


    cmp    eax, _FocusIn_
    jne    not_FocusIn
; ************************************************* FocusIn Event ****
is_FocusIn:
    lea    esi, [XEvent_FocusIn]
    lea    edi, [evtmsg_FocusIn]
    jmp    fill_XEvent_structure
not_FocusIn:


    cmp    eax, _FocusOut_
    jne    not_FocusOut
; ************************************************ FocusOut Event ****
is_FocusOut:
    lea    esi, [XEvent_FocusOut]
    lea    edi, [evtmsg_FocusOut]
    jmp    fill_XEvent_structure
not_FocusOut:


    cmp    eax, _KeymapNotify_
    jne    not_KeymapNotify
; ******************************************** KeymapNotify Event ****
is_KeymapNotify:
    lea    esi, [XEvent_KeymapNotify]
    lea    edi, [evtmsg_KeymapNotify]
    jmp    fill_XEvent_structure
not_KeymapNotify:


    cmp    eax, _Expose_
    jne    not_Expose
; ************************************************** Expose Event ****
is_Expose:
    lea    esi, [XEvent_Expose]
    lea    edi, [evtmsg_Expose]
    jmp    fill_XEvent_structure
not_Expose:


    cmp    eax, _GraphicsExposure_
    jne    not_GraphicsExposure
; **************************************** GraphicsExposure Event ****
is_GraphicsExposure:
    lea    esi, [XEvent_GraphicsExposure]
    lea    edi, [evtmsg_GraphicsExposure]
    jmp    fill_XEvent_structure
not_GraphicsExposure:


    cmp    eax, _NoExposure_
    jne    not_NoExposure
; ********************************************** NoExposure Event ****
is_NoExposure:
    lea    esi, [XEvent_NoExposure]
    lea    edi, [evtmsg_NoExposure]
    jmp    fill_XEvent_structure
not_NoExposure:


    cmp    eax, _VisibilityNotify_
    jne    not_VisibilityNotify
; **************************************** VisibilityNotify Event ****
is_VisibilityNotify:
    lea    esi, [XEvent_VisibilityNotify]
    lea    edi, [evtmsg_VisibilityNotify]
    jmp    fill_XEvent_structure
not_VisibilityNotify:


    cmp    eax, _CreateNotify_
    jne    not_CreateNotify
; ******************************************** CreateNotify Event ****
is_CreateNotify:
    lea    esi, [XEvent_CreateNotify]
    lea    edi, [evtmsg_CreateNotify]
    jmp    fill_XEvent_structure
not_CreateNotify:


    cmp    eax, _DestroyNotify_
    jne    not_DestroyNotify
; ******************************************* DestroyNotify Event ****
is_DestroyNotify:
    lea    esi, [XEvent_DestroyNotify]
    lea    edi, [evtmsg_DestroyNotify]
    jmp    fill_XEvent_structure
not_DestroyNotify:


    cmp    eax, _UnmapNotify_
    jne    not_UnmapNotify
; ********************************************* UnmapNotify Event ****
is_UnmapNotify:
    lea    esi, [XEvent_UnmapNotify]
    lea    edi, [evtmsg_UnmapNotify]
    jmp    fill_XEvent_structure
not_UnmapNotify:


    cmp    eax, _MapNotify_
    jne    not_MapNotify
; *********************************************** MapNotify Event ****
is_MapNotify:
    lea    esi, [XEvent_MapNotify]
    lea    edi, [evtmsg_MapNotify]
    jmp    fill_XEvent_structure
not_MapNotify:


    cmp    eax, _MapRequest_
    jne    not_MapRequest
; ********************************************** MapRequest Event ****
is_MapRequest:
    lea    esi, [XEvent_MapRequest]
    lea    edi, [evtmsg_MapRequest]
    jmp    fill_XEvent_structure
not_MapRequest:


    cmp    eax, _ReparentNotify_
    jne    not_ReparentNotify
; ****************************************** ReparentNotify Event ****
is_ReparentNotify:
    lea    esi, [XEvent_ReparentNotify]
    lea    edi, [evtmsg_ReparentNotify]
    jmp    fill_XEvent_structure
not_ReparentNotify:


    cmp    eax, _ConfigureNotify_
    jne    not_ConfigureNotify
; ***************************************** ConfigureNotify Event ****
is_ConfigureNotify:
    lea    esi, [XEvent_ConfigureNotify]
    lea    edi, [evtmsg_ConfigureNotify]
    jmp    fill_XEvent_structure
not_ConfigureNotify:


    cmp    eax, _ConfigureRequest_
    jne    not_ConfigureRequest
; **************************************** ConfigureRequest Event ****
is_ConfigureRequest:
    lea    esi, [XEvent_ConfigureRequest]
    lea    edi, [evtmsg_ConfigureRequest]
    jmp    fill_XEvent_structure
not_ConfigureRequest:


    cmp    eax, _GravityNotify_
    jne    not_GravityNotify
; ******************************************* GravityNotify Event ****
is_GravityNotify:
    lea    esi, [XEvent_GravityNotify]
    lea    edi, [evtmsg_GravityNotify]
    jmp    fill_XEvent_structure
not_GravityNotify:


    cmp    eax, _ResizeRequest_
    jne    not_ResizeRequest
; ************************************************* ResizeRequest ****
is_ResizeRequest:
    lea    esi, [XEvent_ResizeRequest]
    lea    edi, [evtmsg_ResizeRequest]
    jmp    fill_XEvent_structure
not_ResizeRequest:


    cmp    eax, _CirculateNotify_
    jne    not_CirculateNotify
; ***************************************** CirculateNotify Event ****
is_CirculateNotify:
    lea    esi, [XEvent_CirculateNotify]
    lea    edi, [evtmsg_CirculateNotify]
    jmp    fill_XEvent_structure
not_CirculateNotify:


    cmp    eax, _CirculateRequest_
    jne    not_CirculateRequest
; **************************************** CirculateRequest Event ****
is_CirculateRequest:
    lea    esi, [XEvent_CirculateRequest]
    lea    edi, [evtmsg_CirculateRequest]
    jmp    fill_XEvent_structure
not_CirculateRequest:


    cmp    eax, _PropertyNotify_
    jne    not_PropertyNotify
; ****************************************** PropertyNotify Event ****
is_PropertyNotify:
    lea    esi, [XEvent_PropertyNotify]
    lea    edi, [evtmsg_PropertyNotify]
    jmp    fill_XEvent_structure
not_PropertyNotify:


    cmp    eax, _SelectionClear_
    jne    not_SelectionClear
; ****************************************** SelectionClear Event ****
is_SelectionClear:
    lea    esi, [XEvent_SelectionClear]
    lea    edi, [evtmsg_SelectionClear]
    jmp    fill_XEvent_structure
not_SelectionClear:


    cmp    eax, _SelectionRequest_
    jne    not_SelectionRequest
; **************************************** SelectionRequest Event ****
is_SelectionRequest:
    lea    esi, [XEvent_SelectionRequest]
    lea    edi, [evtmsg_SelectionRequest]
    jmp    fill_XEvent_structure
not_SelectionRequest:


    cmp    eax, _SelectionNotify_
    jne    not_SelectionNotify
; ***************************************** SelectionNotify Event ****
is_SelectionNotify:
    lea    esi, [XEvent_SelectionNotify]
    lea    edi, [evtmsg_SelectionNotify]
    jmp    fill_XEvent_structure
not_SelectionNotify:


    cmp    eax, _ColormapNotify_
    jne    not_ColormapNotify
; ****************************************** ColormapNotify Event ****
is_ColormapNotify:
    lea    esi, [XEvent_ColormapNotify]
    lea    edi, [evtmsg_ColormapNotify]
    jmp    fill_XEvent_structure
not_ColormapNotify:


    cmp    eax, _ClientMessage_
    jne    not_ClientMessage
; ******************************************* ClientMessage Event ****
is_ClientMessage:
    lea    esi, [XEvent_ClientMessage]
    lea    edi, [XEvent_ClientMessage]
    jmp    fill_XEvent_structure
not_ClientMessage:


    cmp    eax, _MappingNotify_
    jne    not_MappingNotify
; ******************************************* MappingNotify Event ****
is_MappingNotify:
    lea    esi, [XEvent_MappingNotify]
    lea    edi, [XEvent_MappingNotify]
    jmp    fill_XEvent_structure
not_MappingNotify:


; ************************************************* Unknown Event ****
    lea    esi, [XEvent_unknown]
    lea    edi, [evtmsg_unknown]


fill_XEvent_structure:
; READ( socketX, ESI, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    mov    ecx, esi
    mov    edx, 31
    int    0x80
; WRITE( stdout, EDI, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    mov    ecx, edi
    mov    edx, [evtmsg_len]
    int    0x80




    jmp    mainloop




mainloop_end:




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
