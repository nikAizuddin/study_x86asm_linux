;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;             Face Recognition using Eigenface Algorithm
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 22-FEB-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;       X SERVER: major version 11
;         FORMAT: elf32
;
;=====================================================================

;Include constant symbols and global variables

%include "include/constants.inc"
%include "include/data_kernel.inc"
%include "include/data_strings.inc"
%include "include/data_XServer.inc"
%include "include/data_XRequests.inc"
%include "include/data_XEvent.inc"
%include "include/data_mainProgram.inc"

global _start

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create a TCP socket.
;   We need to use TCP socket to communicate with server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup parameters for the systemcall socket
    mov    dword [args.param1], _PF_LOCAL_    ;protocol family
    mov    dword [args.param2], _SOCK_STREAM_ ;socket type
    mov    dword [args.param3], _IPPROTO_IP_  ;protocol used

;SOCKETCALL( _CALL_SOCKET_, @args )
;The socketcall() will be directed to call_socket().
;See Linux manual page for more info.
    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _CALL_SOCKET_
    lea    ecx, [args]
    int    0x80

;Check to make sure the SOCKETCALL() have no errors
;The socketcall will return negative if error.
    test   eax, eax
    js     socket_create_fail
    jmp    socket_create_success

socket_create_fail:

;WRITE( _STDOUT_, @errmsg_socketCreate, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_socketCreate]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

socket_create_success:

;If success, save the socket number. We will use this socketX
;to communicate with X Server.
    mov    [socketX], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Connect to X Server.
;   Use "/tmp/.X11-unix/X0" file to contact the X Server.
;   Without this file, we will unable to contact and connect with
;   X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup parameters for the systemcall connect
    mov    eax, [socketX]
    lea    ebx, [contactX]
    mov    ecx, [contactX_size]
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    [args.param3], ecx

;SOCKETCALL( _CALL_CONNECT_, @args )
;Connect to X Server.
    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _CALL_CONNECT_
    lea    ecx, [args]
    int    0x80

;Check to make sure the program successfully connect with X Server
    test   eax, eax
    js     connect_XServer_fail
    jmp    connect_XServer_success

connect_XServer_fail:

;WRITE( _STDOUT_, @errmsg_connect_XServer, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_connect_XServer]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

connect_XServer_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set TCP socketX to non-blocking mode.
;   By default, TCP socket are in blocking mode. It is important
;   to use a non-blocking socket.
;
;   If TCP socket in blocking mode, when system call read is used to
;   read data from the socket, the program waits for resources, if
;   the resources are unavailable.
;
;   If TCP socket in non-blocking mode, the program does not wait
;   for resources if they are unavailable.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;FCNTL64( socketX, _F_SETFL_, _O_RDWR_ | _O_NONBLOCK_ )
    mov    eax, _SYSCALL_FCNTL64_
    mov    ebx, [socketX]
    mov    ecx, _F_SETFL_
    lea    edx, [_O_RDWR_ + _O_NONBLOCK_]
    int    0x80

;Check to make sure the socket is properly set to non-blocking mode
    test   eax, eax
    js     set_nonBlocking_fail
    jmp    set_nonBlocking_success

set_nonBlocking_fail:

;WRITE( _STDOUT_, @errmsg_set_nonBlocking, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_set_nonBlocking]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

set_nonBlocking_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure the X Server is ready to receive requests.
;   When the server is ready, we will authenticate
;   our connection with the X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup parameters for systemcall poll
    mov    eax, [socketX] ;Initialized for the first time only
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Authenticate our connection with the X Server.
;   We don't use Xauthority file to authenticate, but just
;   simply tell the X Server major version is already sufficient.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;WRITE( socketX, @authenticateX, authenticateX_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [authenticateX]
    mov    edx, [authenticateX_size]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the X Server to process the authenticate request, and
;   become ready for sending reply about our authentication status.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLIN_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the first 2 bytes of data, to check
;   whether our authentication is success or fail
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;READ( socketX, @authenticateStatus, 2 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [authenticateStatus]
    mov    edx, 2
    int    0x80

;Check to make sure the READ() systemcall have no errors
    test   eax, eax
    js     get_authStatus_fail
    jmp    get_authStatus_success

get_authStatus_fail:

;WRITE( _STDOUT_, @errmsg_get_authStatus, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_get_authStatus]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

get_authStatus_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check our authentication status.
;   The value received should be 1. Values
;   other than 1 are considered as failure by the program.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    xor    eax, eax
    mov    al, [authenticateStatus]
    cmp    eax, 1
    jne    authStatus_fail
    jmp    authStatus_success

authStatus_fail:

;WRITE( _STDOUT_, @errmsg_authStatus, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_authStatus]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

authStatus_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive header information about the additional data.
;   When the authentication is success, the server will send
;   additional data. However, we have to get its header information
;   first, because it contains the length of additinal data.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;READ( socketX, @authenticateSuccess, 6 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [authenticateSuccess]
    mov    edx, 6
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the additional data.
;   This additional data is needed for creating windows and others.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;READ( socketX, @additionalData, authenticateSuccess.lenAddData*4 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [additionalData]
    mov    edx, [authenticateSuccess.lenAddData]
    lea    edx, [edx * 4]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Extract useful values from the additional data.
;   This program only extract useful values from the additional data.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [additionalData]

;Fill additional data in our XServer data structure
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

;Get vendor name and fill into XServer.vendorStr.
;But first we have to calculate the length of the string
;in double word units.
    xor    eax, eax
    xor    edx, edx
    mov    ebx, 4
    mov    ax, [XServer.nbytesVendor]
    div    ebx
    shr    edx, 1
    add    eax, edx
    mov    ecx, eax
    rep    movsd

;Get screen structure from the additional data
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
;   Request CreateWindow.
;   This request will create the mainWindow.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Make sure the X Server is ready to receive requests.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;Initialize create_mainWindow structure, we will pass
;this structure as the CreateWindow request.
    mov    eax, [XServer.ridBase]
    mov    ebx, [XScreen.root]
    mov    ecx, [XScreen.blackPixel]
    mov    edx, [XScreen.whitePixel]
    mov    [createWindow_TrainingImages.wid], eax
    mov    [createWindow_TrainingImages.parent], ebx
    mov    [createWindow_TrainingImages.backgroundPixel], ecx
    mov    [createWindow_TrainingImages.borderPixel], edx

;WRITE( socketX, @create_mainWindow, create_main...requestLength*4 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createWindow_TrainingImages]
    mov    edx, [createWindow_TrainingImages.requestLength]
    lea    edx, [edx * 4]
    int    0x80


;Wait 100ms for the X Server to process the CreateWindow request.
;The X Server will send a reply if the request is fail.
;If the request is success, the X Server will not send any reply.
;POLL( @poll, 1, _POLL_SHORT_TIMEOUT_ )
    mov    ebx, _POLLIN_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_SHORT_TIMEOUT_
    int    0x80

;Check if poll.revents == _POLLIN_,
;thats mean there are something wrong, and server
;will return error code.
    xor    eax, eax
    mov    ax, [poll.revents]
    mov    ebx, _POLLIN_
    cmp    eax, ebx
    je     create_mainWindow_fail
    jmp    create_mainWindow_success

create_mainWindow_fail:

;READ( socketX, @requestStatus, 32 )
;Get the reason why CreateWindow request fail
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [requestStatus]
    mov    edx, 32
    int    0x80

;WRITE( _STDOUT_, @errmsg_createWinTImg, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_createWinTImg]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

create_mainWindow_success:

    mov    eax, [createWindow_TrainingImages.wid]
    movzx  bx, [createWindow_TrainingImages.width]
    movzx  cx, [createWindow_TrainingImages.height]
    mov    [winTrainingImages.wid], eax
    mov    [winTrainingImages.width], bx
    mov    [winTrainingImages.height], cx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create winMeanSubtracted
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Make sure the X Server is ready to receive the request.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;Initialize create_mainWindow structure, we will pass
;this structure as the CreateWindow request.
    mov    eax, [XServer.ridBase]
    mov    ebx, [XScreen.root]
    mov    ecx, [XScreen.blackPixel]
    mov    edx, [XScreen.whitePixel]
    add    eax, 0x100000
    mov    [createWindow_meanSubtracted.wid], eax
    mov    [createWindow_meanSubtracted.parent], ebx
    mov    [createWindow_meanSubtracted.backgroundPixel], ecx
    mov    [createWindow_meanSubtracted.borderPixel], edx

;WRITE( socketX, @createWindow_meanSubtracted, requestLength*4 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createWindow_meanSubtracted]
    mov    edx, [createWindow_meanSubtracted.requestLength]
    lea    edx, [edx * 4]
    int    0x80

;Wait 100ms for the X Server to process the CreateWindow request.
;The X Server will send a reply if the request is fail.
;If the request is success, the X Server will not send any reply.
;POLL( @poll, 1, _POLL_SHORT_TIMEOUT_ )
    mov    ebx, _POLLIN_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_SHORT_TIMEOUT_
    int    0x80

;Check if poll.revents == _POLLIN_
    xor    eax, eax
    mov    ax, [poll.revents]
    mov    ebx, _POLLIN_
    cmp    eax, ebx
    je     createWindow_meanSubtracted_fail
    jmp    createWindow_meanSubtracted_success

createWindow_meanSubtracted_fail:

;READ( socketX, @requestStatus, 32 )
;Get the reason why CreateWindow request fail
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [requestStatus]
    mov    edx, 32
    int    0x80

;WRITE( _STDOUT_, @errmsg_createWinMSubtr, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_createWinMSubtr]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

createWindow_meanSubtracted_success:

    mov    eax, [createWindow_meanSubtracted.wid]
    movzx  bx, [createWindow_meanSubtracted.width]
    movzx  cx, [createWindow_meanSubtracted.height]
    mov    [winMeanSubtracted.wid], eax
    mov    [winMeanSubtracted.width], bx
    mov    [winMeanSubtracted.height], cx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request WM_DELETE_WINDOW atom message using InternAtom request.
;   The WM_DELETE_WINDOW atom is needed to modify the WM_PROTOCOLS,
;   so that the connection with the X Server does not unexpectedly
;   disconnected when the mainWindow is deleted.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Make sure the X Server is ready to receive the request.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @getWMDeleteMessage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [getWMDeleteMessage]
    mov    edx, 24
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the requested WM_DELETE_WINDOW atom.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;But, wait for the X Server to process the InternAtom request.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLIN_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;Okay, X Server is ready and now receive the WM_DELETE_WINDOW atom.
;READ( socketX, @InternAtom_reply, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [InternAtom_reply]
    mov    edx, 32
    int    0x80

;Save the atom
    mov    eax, [InternAtom_reply.atom]
    mov    [WMDeleteMessage], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request WM_PROTOCOLS atom property using InternAtom request.
;   We need the WM_PROTOCOLS atom property in order to apply the
;   WM_DELETE_WINDOW atom.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Make sure the X Server is ready to receive next request.
;POLL( [poll.fd, poll.events], 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @getWMProtocols, 20 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [getWMProtocols]
    mov    edx, 20
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Receive the requested WM_PROTOCOLS property atom.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Wait for the X Server to process the InternAtom request
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLIN_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;Okay, X Server has process the request, and the program can now
;receive the atom.
;READ( socketX, @InternAtom_reply, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [InternAtom_reply]
    mov    edx, 32
    int    0x80

;Save the atom
    mov    eax, [InternAtom_reply.atom]
    mov    [WMProtocols], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create X Graphic Context (GC) for winTrainingImages.
;   Graphic Context (GC) is needed for PutImage request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Make sure the X Server is ready to receive the request.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;Setup graphicContext structure.
;We will send this structure as CreateGC request.
    mov    eax, [XServer.ridBase]
    add    eax, 1
    mov    ebx, [winTrainingImages.wid]
    mov    [createGraphicContext_winTrainingImages.cid], eax
    mov    [createGraphicContext_winTrainingImages.drawable], ebx

;Request X Graphic Context
;WRITE( socketX, @create_graphicContext, 20 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createGraphicContext_winTrainingImages]
    mov    edx, 20
    int    0x80

;Save the winTrainingImages X Graphic Context ID
    mov    eax, [createGraphicContext_winTrainingImages.cid]
    mov    [winTrainingImages.cid], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create X Graphic Context (GC) for winMeanSubtracted
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Make sure the X Server is ready to receive the request.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;Setup graphicContext structure.
;We will send this structure as CreateGC request.
    mov    eax, [XServer.ridBase]
    add    eax, (0x100000 + 1)
    mov    ebx, [winMeanSubtracted.wid]
    mov    [createGraphicContext_winMeanSubtracted.cid], eax
    mov    [createGraphicContext_winMeanSubtracted.drawable], ebx

;Request X Graphic Context
;WRITE( socketX, @create_graphicContext, 20 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createGraphicContext_winMeanSubtracted]
    mov    edx, 20
    int    0x80

;Save the winTrainingImages X Graphic Context ID
    mov    eax, [createGraphicContext_winMeanSubtracted.cid]
    mov    [winMeanSubtracted.cid], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load ORL Database image.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%include "subroutines/load_orldatabase.asm"


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find the mean faces of the ORL Database
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%include "subroutines/find_orldatabase_mean_faces.asm"


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create pixmaps
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%include "subroutines/create_pixmaps.asm"


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Upload XImages
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%include "subroutines/upload_ximages.asm"


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize copyArea structures for winTrainingImages
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize copyArea_s01_01 structure

    mov    eax, [winTrainingImages.s01_01_pid] ;src=pixmap
    mov    ebx, [winTrainingImages.s01_02_pid]
    mov    ecx, [winTrainingImages.s01_03_pid]
    mov    edx, [winTrainingImages.s01_04_pid]
    mov    esi, [winTrainingImages.s01_05_pid]
    mov    [copyArea_s01_01.srcDrawable], eax
    mov    [copyArea_s01_02.srcDrawable], ebx
    mov    [copyArea_s01_03.srcDrawable], ecx
    mov    [copyArea_s01_04.srcDrawable], edx
    mov    [copyArea_s01_05.srcDrawable], esi

    mov    eax, [winTrainingImages.s02_01_pid]
    mov    ebx, [winTrainingImages.s02_02_pid]
    mov    ecx, [winTrainingImages.s02_03_pid]
    mov    edx, [winTrainingImages.s02_04_pid]
    mov    esi, [winTrainingImages.s02_05_pid]
    mov    [copyArea_s02_01.srcDrawable], eax
    mov    [copyArea_s02_02.srcDrawable], ebx
    mov    [copyArea_s02_03.srcDrawable], ecx
    mov    [copyArea_s02_04.srcDrawable], edx
    mov    [copyArea_s02_05.srcDrawable], esi

    mov    eax, [winTrainingImages.s03_01_pid]
    mov    ebx, [winTrainingImages.s03_02_pid]
    mov    ecx, [winTrainingImages.s03_03_pid]
    mov    edx, [winTrainingImages.s03_04_pid]
    mov    esi, [winTrainingImages.s03_05_pid]
    mov    [copyArea_s03_01.srcDrawable], eax
    mov    [copyArea_s03_02.srcDrawable], ebx
    mov    [copyArea_s03_03.srcDrawable], ecx
    mov    [copyArea_s03_04.srcDrawable], edx
    mov    [copyArea_s03_05.srcDrawable], esi

    mov    eax, [winTrainingImages.s04_01_pid]
    mov    ebx, [winTrainingImages.s04_02_pid]
    mov    ecx, [winTrainingImages.s04_03_pid]
    mov    edx, [winTrainingImages.s04_04_pid]
    mov    esi, [winTrainingImages.s04_05_pid]
    mov    [copyArea_s04_01.srcDrawable], eax
    mov    [copyArea_s04_02.srcDrawable], ebx
    mov    [copyArea_s04_03.srcDrawable], ecx
    mov    [copyArea_s04_04.srcDrawable], edx
    mov    [copyArea_s04_05.srcDrawable], esi

    mov    eax, [winTrainingImages.s05_01_pid]
    mov    ebx, [winTrainingImages.s05_02_pid]
    mov    ecx, [winTrainingImages.s05_03_pid]
    mov    edx, [winTrainingImages.s05_04_pid]
    mov    esi, [winTrainingImages.s05_05_pid]
    mov    [copyArea_s05_01.srcDrawable], eax
    mov    [copyArea_s05_02.srcDrawable], ebx
    mov    [copyArea_s05_03.srcDrawable], ecx
    mov    [copyArea_s05_04.srcDrawable], edx
    mov    [copyArea_s05_05.srcDrawable], esi


    mov    eax, [winTrainingImages.wid] ;dst=window
    mov    [copyArea_s01_01.dstDrawable], eax
    mov    [copyArea_s01_02.dstDrawable], eax
    mov    [copyArea_s01_03.dstDrawable], eax
    mov    [copyArea_s01_04.dstDrawable], eax
    mov    [copyArea_s01_05.dstDrawable], eax

    mov    [copyArea_s02_01.dstDrawable], eax
    mov    [copyArea_s02_02.dstDrawable], eax
    mov    [copyArea_s02_03.dstDrawable], eax
    mov    [copyArea_s02_04.dstDrawable], eax
    mov    [copyArea_s02_05.dstDrawable], eax

    mov    [copyArea_s03_01.dstDrawable], eax
    mov    [copyArea_s03_02.dstDrawable], eax
    mov    [copyArea_s03_03.dstDrawable], eax
    mov    [copyArea_s03_04.dstDrawable], eax
    mov    [copyArea_s03_05.dstDrawable], eax

    mov    [copyArea_s04_01.dstDrawable], eax
    mov    [copyArea_s04_02.dstDrawable], eax
    mov    [copyArea_s04_03.dstDrawable], eax
    mov    [copyArea_s04_04.dstDrawable], eax
    mov    [copyArea_s04_05.dstDrawable], eax

    mov    [copyArea_s05_01.dstDrawable], eax
    mov    [copyArea_s05_02.dstDrawable], eax
    mov    [copyArea_s05_03.dstDrawable], eax
    mov    [copyArea_s05_04.dstDrawable], eax
    mov    [copyArea_s05_05.dstDrawable], eax


    mov    eax, [winTrainingImages.cid]
    mov    [copyArea_s01_01.gc], eax
    mov    [copyArea_s01_02.gc], eax
    mov    [copyArea_s01_03.gc], eax
    mov    [copyArea_s01_04.gc], eax
    mov    [copyArea_s01_05.gc], eax

    mov    [copyArea_s02_01.gc], eax
    mov    [copyArea_s02_02.gc], eax
    mov    [copyArea_s02_03.gc], eax
    mov    [copyArea_s02_04.gc], eax
    mov    [copyArea_s02_05.gc], eax

    mov    [copyArea_s03_01.gc], eax
    mov    [copyArea_s03_02.gc], eax
    mov    [copyArea_s03_03.gc], eax
    mov    [copyArea_s03_04.gc], eax
    mov    [copyArea_s03_05.gc], eax

    mov    [copyArea_s04_01.gc], eax
    mov    [copyArea_s04_02.gc], eax
    mov    [copyArea_s04_03.gc], eax
    mov    [copyArea_s04_04.gc], eax
    mov    [copyArea_s04_05.gc], eax

    mov    [copyArea_s05_01.gc], eax
    mov    [copyArea_s05_02.gc], eax
    mov    [copyArea_s05_03.gc], eax
    mov    [copyArea_s05_04.gc], eax
    mov    [copyArea_s05_05.gc], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize copyArea structures for winMeanSubtracted
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, [winMeanSubtracted.s01_01_pid] ;src=pixmap
    mov    ebx, [winMeanSubtracted.s01_02_pid]
    mov    ecx, [winMeanSubtracted.s01_03_pid]
    mov    edx, [winMeanSubtracted.s01_04_pid]
    mov    esi, [winMeanSubtracted.s01_05_pid]
    mov    [copyArea_s01_01_meanSubtracted.srcDrawable], eax
    mov    [copyArea_s01_02_meanSubtracted.srcDrawable], ebx
    mov    [copyArea_s01_03_meanSubtracted.srcDrawable], ecx
    mov    [copyArea_s01_04_meanSubtracted.srcDrawable], edx
    mov    [copyArea_s01_05_meanSubtracted.srcDrawable], esi

    mov    eax, [winMeanSubtracted.s02_01_pid]
    mov    ebx, [winMeanSubtracted.s02_02_pid]
    mov    ecx, [winMeanSubtracted.s02_03_pid]
    mov    edx, [winMeanSubtracted.s02_04_pid]
    mov    esi, [winMeanSubtracted.s02_05_pid]
    mov    [copyArea_s02_01_meanSubtracted.srcDrawable], eax
    mov    [copyArea_s02_02_meanSubtracted.srcDrawable], ebx
    mov    [copyArea_s02_03_meanSubtracted.srcDrawable], ecx
    mov    [copyArea_s02_04_meanSubtracted.srcDrawable], edx
    mov    [copyArea_s02_05_meanSubtracted.srcDrawable], esi

    mov    eax, [winMeanSubtracted.s03_01_pid]
    mov    ebx, [winMeanSubtracted.s03_02_pid]
    mov    ecx, [winMeanSubtracted.s03_03_pid]
    mov    edx, [winMeanSubtracted.s03_04_pid]
    mov    esi, [winMeanSubtracted.s03_05_pid]
    mov    [copyArea_s03_01_meanSubtracted.srcDrawable], eax
    mov    [copyArea_s03_02_meanSubtracted.srcDrawable], ebx
    mov    [copyArea_s03_03_meanSubtracted.srcDrawable], ecx
    mov    [copyArea_s03_04_meanSubtracted.srcDrawable], edx
    mov    [copyArea_s03_05_meanSubtracted.srcDrawable], esi

    mov    eax, [winMeanSubtracted.s04_01_pid]
    mov    ebx, [winMeanSubtracted.s04_02_pid]
    mov    ecx, [winMeanSubtracted.s04_03_pid]
    mov    edx, [winMeanSubtracted.s04_04_pid]
    mov    esi, [winMeanSubtracted.s04_05_pid]
    mov    [copyArea_s04_01_meanSubtracted.srcDrawable], eax
    mov    [copyArea_s04_02_meanSubtracted.srcDrawable], ebx
    mov    [copyArea_s04_03_meanSubtracted.srcDrawable], ecx
    mov    [copyArea_s04_04_meanSubtracted.srcDrawable], edx
    mov    [copyArea_s04_05_meanSubtracted.srcDrawable], esi

    mov    eax, [winMeanSubtracted.s05_01_pid]
    mov    ebx, [winMeanSubtracted.s05_02_pid]
    mov    ecx, [winMeanSubtracted.s05_03_pid]
    mov    edx, [winMeanSubtracted.s05_04_pid]
    mov    esi, [winMeanSubtracted.s05_05_pid]
    mov    [copyArea_s05_01_meanSubtracted.srcDrawable], eax
    mov    [copyArea_s05_02_meanSubtracted.srcDrawable], ebx
    mov    [copyArea_s05_03_meanSubtracted.srcDrawable], ecx
    mov    [copyArea_s05_04_meanSubtracted.srcDrawable], edx
    mov    [copyArea_s05_05_meanSubtracted.srcDrawable], esi

    mov    eax, [winMeanSubtracted.wid] ;dst=window
    mov    [copyArea_s01_01_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s01_02_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s01_03_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s01_04_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s01_05_meanSubtracted.dstDrawable], eax

    mov    [copyArea_s02_01_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s02_02_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s02_03_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s02_04_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s02_05_meanSubtracted.dstDrawable], eax

    mov    [copyArea_s03_01_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s03_02_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s03_03_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s03_04_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s03_05_meanSubtracted.dstDrawable], eax

    mov    [copyArea_s04_01_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s04_02_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s04_03_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s04_04_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s04_05_meanSubtracted.dstDrawable], eax

    mov    [copyArea_s05_01_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s05_02_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s05_03_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s05_04_meanSubtracted.dstDrawable], eax
    mov    [copyArea_s05_05_meanSubtracted.dstDrawable], eax

    mov    eax, [winMeanSubtracted.cid]
    mov    [copyArea_s01_01_meanSubtracted.gc], eax
    mov    [copyArea_s01_02_meanSubtracted.gc], eax
    mov    [copyArea_s01_03_meanSubtracted.gc], eax
    mov    [copyArea_s01_04_meanSubtracted.gc], eax
    mov    [copyArea_s01_05_meanSubtracted.gc], eax

    mov    [copyArea_s02_01_meanSubtracted.gc], eax
    mov    [copyArea_s02_02_meanSubtracted.gc], eax
    mov    [copyArea_s02_03_meanSubtracted.gc], eax
    mov    [copyArea_s02_04_meanSubtracted.gc], eax
    mov    [copyArea_s02_05_meanSubtracted.gc], eax

    mov    [copyArea_s03_01_meanSubtracted.gc], eax
    mov    [copyArea_s03_02_meanSubtracted.gc], eax
    mov    [copyArea_s03_03_meanSubtracted.gc], eax
    mov    [copyArea_s03_04_meanSubtracted.gc], eax
    mov    [copyArea_s03_05_meanSubtracted.gc], eax

    mov    [copyArea_s04_01_meanSubtracted.gc], eax
    mov    [copyArea_s04_02_meanSubtracted.gc], eax
    mov    [copyArea_s04_03_meanSubtracted.gc], eax
    mov    [copyArea_s04_04_meanSubtracted.gc], eax
    mov    [copyArea_s04_05_meanSubtracted.gc], eax

    mov    [copyArea_s05_01_meanSubtracted.gc], eax
    mov    [copyArea_s05_02_meanSubtracted.gc], eax
    mov    [copyArea_s05_03_meanSubtracted.gc], eax
    mov    [copyArea_s05_04_meanSubtracted.gc], eax
    mov    [copyArea_s05_05_meanSubtracted.gc], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request ChangeProperty, to modify the mainWindow properties.
;   We need to use the ChangeProperty request to apply the
;   WM_DELETE_WINDOW atom to the mainWindow.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Make sure the X Server is ready to receive the next request.
;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

    mov    eax, [winTrainingImages.wid]
    mov    ebx, [WMDeleteMessage]
    mov    ecx, [WMProtocols]
;Setup setWindowDeleteMsg structure
    mov    [setWindowDeleteMsg.window], eax
    mov    [setWindowDeleteMsg.data], ebx
    mov    [setWindowDeleteMsg.property], ecx
;Setup setWindowName structure
    mov    [setWindowName.window], eax
;Setup setWindowSizeHints structure
    mov    [setWindowSizeHints.window], eax
;Setup setWindowManagerHints
    mov    [setWindowManagerHints.window], eax

;WRITE( socketX, @setWindowDeleteMsg, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowDeleteMsg]
    mov    edx, 28 ;setWindowDeleteMsg.requestLength * 4
    int    0x80
;WRITE( socketX, @setWindowName, 44 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowName]
    mov    edx, 44 ;setWindowName.requestLength * 4
    int    0x80
;WRITE( socketX, @setWindowSizeHints, 96 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowSizeHints]
    mov    edx, 96 ;setWindowSizeHints.requestLength * 4
    int    0x80
;WRITE( socketX, @setWindowManagerHints, 60 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowManagerHints]
    mov    edx, 60
    int    0x80

;--------------------------------------------------------------------

    mov    eax, [winMeanSubtracted.wid]
    mov    ebx, [WMDeleteMessage]
    mov    ecx, [WMProtocols]
;Setup setWindowDeleteMsg structure
    mov    [setWindowDeleteMsg.window], eax
    mov    [setWindowDeleteMsg.data], ebx
    mov    [setWindowDeleteMsg.property], ecx
;Setup setWindowName structure
    mov    [setWindowName_meanSubtracted.window], eax
;Setup setWindowSizeHints structure
    mov    [setWindowSizeHints.window], eax
;Setup setWindowManagerHints
    mov    [setWindowManagerHints.window], eax

;WRITE( socketX, @setWindowDeleteMsg, 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowDeleteMsg]
    mov    edx, 28 ;setWindowDeleteMsg.requestLength * 4
    int    0x80
;WRITE( socketX, @setWindowName_meanSubtracted, 44 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowName_meanSubtracted]
    mov    edx, 44 ;setWindowName.requestLength * 4
    int    0x80
;WRITE( socketX, @setWindowSizeHints, 96 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowSizeHints]
    mov    edx, 96 ;setWindowSizeHints.requestLength * 4
    int    0x80
;WRITE( socketX, @setWindowManagerHints, 60 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [setWindowManagerHints]
    mov    edx, 60
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure the X Server is ready to receive the next request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Requst MapWindow to map the mainWindow.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup mapWindow structure for the mainWindow
    mov    eax, [winTrainingImages.wid]
    mov    [mapWindow.wid], eax

;WRITE( socketX, @mapWindow, 8 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [mapWindow]
    mov    edx, 8
    int    0x80

;Setup mapWindow structure for the winMeanSubtracted
    mov    eax, [winMeanSubtracted.wid]
    mov    [mapWindow.wid], eax

;WRITE( socketX, @mapWindow, 8 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [mapWindow]
    mov    edx, 8
    int    0x80




align 16, nop
mainloop:




;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for events from the X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLIN_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check the type of event received
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;READ( socketX, @XEventReply, 1 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEventReply]
    mov    edx, 1
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Go to the function that is responsible to handle which
;   type of event received.
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


;Unknown events are treated as ClientMessage in this program.
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

;SOCKETCALL( _CALL_SHUTDOWN_, @[socketX, _SHUT_RDWR_] )
;Shutdown the TCP socket.
    mov    eax, [socketX]
    mov    ebx, _SHUT_RDWR_
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _CALL_SHUTDOWN_
    lea    ecx, [args]
    int    0x80

;CLOSE( socketX ) 
;Close the TCP socket.
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socketX]
    int    0x80

;EXIT( 0 )
    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx
    int    0x80

exit_failure:

;CLOSE( socketX )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socketX]
    int    0x80

;EXIT( -1 )
    mov    eax, _SYSCALL_EXIT_
    mov    ebx, -1
    int    0x80




; ####################################################################
;
;
;
;                         XEvent Functions
;
;
;
; ####################################################################

%include "XEventFunctions/XEventFunc_KeyPress.asm"
%include "XEventFunctions/XEventFunc_KeyRelease.asm"
%include "XEventFunctions/XEventFunc_ButtonPress.asm"
%include "XEventFunctions/XEventFunc_ButtonRelease.asm"
%include "XEventFunctions/XEventFunc_MotionNotify.asm"
%include "XEventFunctions/XEventFunc_EnterNotify.asm"
%include "XEventFunctions/XEventFunc_LeaveNotify.asm"
%include "XEventFunctions/XEventFunc_FocusIn.asm"
%include "XEventFunctions/XEventFunc_FocusOut.asm"
%include "XEventFunctions/XEventFunc_KeymapNotify.asm"
%include "XEventFunctions/XEventFunc_Expose.asm"
%include "XEventFunctions/XEventFunc_GraphicsExposure.asm"
%include "XEventFunctions/XEventFunc_NoExposure.asm"
%include "XEventFunctions/XEventFunc_VisibilityNotify.asm"
%include "XEventFunctions/XEventFunc_CreateNotify.asm"
%include "XEventFunctions/XEventFunc_DestroyNotify.asm"
%include "XEventFunctions/XEventFunc_UnmapNotify.asm"
%include "XEventFunctions/XEventFunc_MapNotify.asm"
%include "XEventFunctions/XEventFunc_MapRequest.asm"
%include "XEventFunctions/XEventFunc_ReparentNotify.asm"
%include "XEventFunctions/XEventFunc_ConfigureNotify.asm"
%include "XEventFunctions/XEventFunc_ConfigureRequest.asm"
%include "XEventFunctions/XEventFunc_GravityNotify.asm"
%include "XEventFunctions/XEventFunc_ResizeRequest.asm"
%include "XEventFunctions/XEventFunc_CirculateNotify.asm"
%include "XEventFunctions/XEventFunc_CirculateRequest.asm"
%include "XEventFunctions/XEventFunc_PropertyNotify.asm"
%include "XEventFunctions/XEventFunc_SelectionClear.asm"
%include "XEventFunctions/XEventFunc_SelectionRequest.asm"
%include "XEventFunctions/XEventFunc_SelectionNotify.asm"
%include "XEventFunctions/XEventFunc_ColormapNotify.asm"
%include "XEventFunctions/XEventFunc_MappingNotify.asm"
%include "XEventFunctions/XEventFunc_ClientMessage.asm"
