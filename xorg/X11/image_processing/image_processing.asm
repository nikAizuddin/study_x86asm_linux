;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                 Introduction to Image Processing
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 17-FEB-2015
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
;   Make sure the X Server is ready to receive requests.
;   When the server is ready, we will request CreateWindow.
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
;   Request CreateWindow.
;   This request will create the mainWindow.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize create_mainWindow structure, we will pass
;this structure as the CreateWindow request.
    mov    eax, [XServer.ridBase]
    mov    ebx, [XScreen.root]
    mov    ecx, [XScreen.blackPixel]
    mov    edx, [XScreen.whitePixel]
    mov    [create_mainWindow.wid], eax
    mov    [create_mainWindow.parent], ebx
    mov    [create_mainWindow.backgroundPixel], ecx
    mov    [create_mainWindow.borderPixel], edx

;WRITE( socketX, @create_mainWindow, create_main...requestLength*4 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [create_mainWindow]
    mov    edx, [create_mainWindow.requestLength]
    lea    edx, [edx * 4]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait 100ms for the X Server to process the CreateWindow request.
;   The X Server will send a reply if the request is fail.
;   If the request is success, the X Server will not send any reply.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

;WRITE( _STDOUT_, @errmsg_createMainWindow, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_createMainWindow]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

create_mainWindow_success:

    mov    eax, [create_mainWindow.wid]
    movzx  bx, [create_mainWindow.width]
    movzx  cx, [create_mainWindow.height]
    mov    [mainWindow.wid], eax
    mov    [mainWindow.width], bx
    mov    [mainWindow.height], cx


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
;   Request WM_DELETE_WINDOW atom message using InternAtom request.
;   The WM_DELETE_WINDOW atom is needed to modify the WM_PROTOCOLS,
;   so that the connection with the X Server does not unexpectedly
;   disconnected when the mainWindow is deleted.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;WRITE( socketX, @getWMDeleteMessage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [getWMDeleteMessage]
    mov    edx, 24
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the X Server to process the InternAtom request, and
;   become ready to send reply.
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
;   Receive the requested WM_DELETE_WINDOW atom.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;READ( socketX, @InternAtom_reply, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [InternAtom_reply]
    mov    edx, 32
    int    0x80

    mov    eax, [InternAtom_reply.atom]
    mov    [WMDeleteMessage], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure the X Server is ready to receive the next request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;POLL( [poll.fd, poll.events], 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], bx
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Request WM_PROTOCOLS atom property using InternAtom request.
;   We need the WM_PROTOCOLS atom property in order to apply the
;   WM_DELETE_WINDOW atom.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;WRITE( socketX, @getWMProtocols, 20 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [getWMProtocols]
    mov    edx, 20
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for the X Server to process the InternAtom request, and
;   become ready to send reply.
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
;   Receive the requested WM_PROTOCOLS property atom.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;READ( socketX, @InternAtom_reply, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [InternAtom_reply]
    mov    edx, 32
    int    0x80

    mov    eax, [InternAtom_reply.atom]
    mov    [WMProtocols], eax


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
;   Create the graphic context using CreateGC request.
;   Graphic Context (GC) is needed for PutImage request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup graphicContext structure.
;We will send this structure as CreateGC request.
    mov    eax, [XServer.ridBase]
    add    eax, 1
    mov    ebx, [mainWindow.wid]
    mov    [create_graphicContext.cid], eax
    mov    [create_graphicContext.drawable], ebx

;WRITE( socketX, @create_graphicContext, 20 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [create_graphicContext]
    mov    edx, 20
    int    0x80

    mov    eax, [create_graphicContext.cid]
    mov    [mainWindow.cid], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load the "32bit_testimage.bmp" image file.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_image, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_image]
    mov    ecx, _O_RDONLY_
    int    0x80
    test   eax, eax
    js     image_open_fail
    jmp    image_open_success

image_open_fail:

;WRITE( _STDOUT_, @errmsg_imageOpen, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_imageOpen]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

image_open_success:

    mov    [image_fd], eax

;LSEEK( image_fd, 0x8a, _SEEK_SET_ )
;Seek to the offset 0x8a, which contains data pixels.
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0x8a
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @imgRaw.pixel, image_size )
;Fill the imgRaw.pixel with the "32bit_image.bmp" pixels.
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [imgRaw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load "help.bmp" image
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;image_fd = OPEN( @path_helpImage, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_helpImage]
    mov    ecx, _O_RDONLY_
    int    0x80
    test   eax, eax
    js     helpImage_open_fail
    jmp    helpImage_open_success

helpImage_open_fail:

;WRITE( _STDOUT_, @errmsg_imageOpen, errmsg_len )
;Notify user about the error.
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_imageOpen]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

helpImage_open_success:

    mov    [image_fd], eax

;LSEEK( image_fd, 0x8a, _SEEK_SET_ )
;Seek to the offset 0x8a, which contains data pixels.
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [image_fd]
    mov    ecx, 0x8a
    mov    edx, _SEEK_SET_
    int    0x80

;READ( image_fd, @helpImgRaw.pixel, image_size )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [image_fd]
    lea    ecx, [helpImgRaw.pixel]
    mov    edx, (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)
    int    0x80

;CLOSE( image_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [image_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert our test image from ABGR to BGRA.
;   The pixel order in BMP image file is ABGR format, but X Server
;   uses BGRA order.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize the loop
    mov    ecx, _IMG_WIDTH_
    lea    esi, [imgRaw.pixel]
    lea    edi, [XImage.pixel]
    lea    edx, [imgOriginal.pixel]
    mov    ebx, esi
    add    esi, ( (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_) - \
                  _ROWSIZE_8_ )
    pxor   xmm7, xmm7

align 16, nop
loop_convert_ABGR_to_BGRA:

    mov    eax, [esi]
    ror    eax, 8 ;ABGR to BGRA

    movd      xmm0, eax
    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps  xmm0, xmm0

    movdqa [edx], xmm0
    mov    [edi], eax

    add    esi, _COLUMNSIZE_8_
    add    edx, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_8_

    sub    ecx, 1
    jnz    loop_convert_ABGR_to_BGRA

endloop_convert_ABGR_to_BGRA:

    mov    ecx, _IMG_WIDTH_
    sub    esi, (_ROWSIZE_8_ + _ROWSIZE_8_)
    cmp    esi, ebx
    jge    loop_convert_ABGR_to_BGRA

;Copy pixels from imgOriginal to imgCurrent
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)
    lea    esi, [imgOriginal.pixel]
    lea    edi, [imgCurrent.pixel]
    rep    movsd


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert the help image from ABGR to BGRA
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize the loop
    mov    ecx, _IMG_WIDTH_
    lea    esi, [helpImgRaw.pixel]
    lea    edi, [imgHelp.pixel]
    mov    ebx, esi
    add    esi, ( (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_) - \
                  _ROWSIZE_8_ )
    pxor   xmm7, xmm7

align 16, nop
loop_convert_helpImage_ABGR_to_BGRA:

    mov    eax, [esi]
    ror    eax, 8

    mov    [edi], eax

    add    esi, _COLUMNSIZE_8_
    add    edi, _COLUMNSIZE_8_

    sub    ecx, 1
    jnz    loop_convert_helpImage_ABGR_to_BGRA

endloop_convert_helpImage_ABGR_to_BGRA:

    mov    ecx, _IMG_WIDTH_
    sub    esi, (_ROWSIZE_8_ + _ROWSIZE_8_)
    cmp    esi, ebx
    jge    loop_convert_helpImage_ABGR_to_BGRA


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
;   Create mainWindow pixmap using CreatePixmap request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Setup createPixmap structure
;We will send this structure as the CreatePixmap request.
    mov    eax, [XServer.ridBase]
    add    eax, 2
    mov    ebx, [mainWindow.wid]
    mov    [createPixmap.pid], eax
    mov    [createPixmap.drawable], ebx

;WRITE( socketX, @createPixmap, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [createPixmap]
    mov    edx, 16
    int    0x80

    mov    eax, [createPixmap.pid]
    mov    [mainWindow.pid], eax


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
;   Upload XImage.pixel to mainWindow pixmap by using
;   PutImage request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

;Initialize putImage structure
;We will use this structure as the PutImage request.
    mov    eax, [mainWindow.pid]
    mov    ebx, [mainWindow.cid]
    mov    [putImage.drawable], eax
    mov    [putImage.gc], ebx

;Initialize loop
    lea    edi, [XImage.pixel]
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

loop_upload_XImage:

;POLL( {socketX, _POLLOUT_}, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    ebx, _POLLOUT_
    mov    [poll.events], ebx 
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage]
    mov    edx, 24
    int    0x80

    mov    eax, [putImage.dstY]
    add    eax, 10
    mov    [putImage.dstY], eax

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_
    cmp    edi, esi
    jbe    loop_upload_XImage

endloop_upload_XImage:


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
;   Copy the drawed image from mainWindow.pixmap to mainWindow.window
;   by using CopyArea request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Initialize copyArea structure
    mov    eax, [mainWindow.pid] ;src=pixmap
    mov    ebx, [mainWindow.wid] ;dst=window
    mov    ecx, [mainWindow.cid]
    mov    [copyArea.srcDrawable], eax
    mov    [copyArea.dstDrawable], ebx
    mov    [copyArea.gc], ecx

;WRITE( socketX, @copyArea 28 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea]
    mov    edx, 28
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
;   Request ChangeProperty, to modify the mainWindow properties.
;   We need to use the ChangeProperty request to apply the
;   WM_DELETE_WINDOW atom to the mainWindow.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, [mainWindow.wid]
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

;Setup mapWindow structure
;We will send this structure as the MapWindow request.
    mov    eax, [mainWindow.wid]
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


; ####################################################################
;
;
;
;                       ImageFilter Functions
;
;
;
; ####################################################################

%include "ImageFilters/SSE2_ImageFilter_NoFilter.asm"
%include "ImageFilters/SSE2_ImageFilter_Mean.asm"
%include "ImageFilters/SSE2_ImageFilter_EDGradient.asm"
