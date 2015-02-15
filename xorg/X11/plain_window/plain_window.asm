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
;       X SERVER: major version 11
;         FORMAT: elf32
;
;=====================================================================

; Include constant symbols and global variables

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
;   Create a TCP socket.
;   We need to use TCP socket to communicate with server.
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

; Check to make sure the SOCKETCALL() have no errors
    test   eax, eax
    js     socket_create_fail
    jmp    socket_create_success

socket_create_fail:

; WRITE( _STDOUT_, @errmsg_socketCreate, errmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_socketCreate]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

socket_create_success:

    mov    [socketX], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Connect to X Server.
;   We will use "/tmp/.X11-unix/X0" file to contact the X Server.
;   Without this file, we will unable to contact and connect with
;   X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall connect
    mov    eax, [socketX]
    lea    ebx, [contactX]
    mov    ecx, [contactX_size]
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    [args.param3], ecx

; SOCKETCALL( _CALL_CONNECT_, @args )
    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _CALL_CONNECT_
    lea    ecx, [args]
    int    0x80

; Check to make sure the program successfully connect with X Server
    test   eax, eax
    js     connect_XServer_fail
    jmp    connect_XServer_success

connect_XServer_fail:

; WRITE( _STDOUT_, @errmsg_connect_XServer, errmsg_len )
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

; FCNTL64( socketX, _F_SETFL_, _O_RDWR_ | _O_NONBLOCK_ )
    mov    eax, _SYSCALL_FCNTL64_
    mov    ebx, [socketX]
    mov    ecx, _F_SETFL_
    lea    edx, [_O_RDWR_ + _O_NONBLOCK_]
    int    0x80

; Check to make sure the socket is properly set to non-blocking mode
    test   eax, eax
    js     set_nonBlocking_fail
    jmp    set_nonBlocking_success

set_nonBlocking_fail:

; WRITE( _STDOUT_, @errmsg_set_nonBlocking, errmsg_len )
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

; Setup parameters for systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; WRITE( socketX, @authenticateX, authenticateX_len )
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

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLIN_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; READ( socketX, @authenticateStatus, 2 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [authenticateStatus]
    mov    edx, 2
    int    0x80

; Check to make sure the READ() systemcall have no errors
    test   eax, eax
    js     get_authStatus_fail
    jmp    get_authStatus_success

get_authStatus_fail:

; WRITE( _STDOUT_, @errmsg_get_authStatus, errmsg_len )
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
;   The first 2 bytes of value received, should be 1. Values
;   other than 1 are considered as failure.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    xor    eax, eax
    mov    al, [authenticateStatus]
    cmp    eax, 1
    jne    authStatus_fail
    jmp    authStatus_success

authStatus_fail:

; WRITE( _STDOUT_, @errmsg_authStatus, errmsg_len )
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

; READ( socketX, @authenticateSuccess, 6 )
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

; READ( socketX, @additionalData, authenticateSuccess.lenAddData*4 )
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

; Get vendor name and fill into XServer.vendorStr.
; But first we have to calculate the length of the string
; in double word units.
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
;   Make sure the X Server is ready to receive requests.
;   When the server is ready, we will request CreateWindow.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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
;   Wait 100ms for the X Server to process the CreateWindow request.
;   The X Server will send a reply if the request is fail.
;   If the request is success, the X Server will not send any reply.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLIN_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_SHORT_TIMEOUT_ )
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_SHORT_TIMEOUT_
    int    0x80

; Check if poll.revents == _POLLIN_
    xor    eax, eax
    mov    ax, [poll.revents]
    mov    ebx, _POLLIN_
    cmp    eax, ebx
    je     create_mainWindow_fail
    jmp    create_mainWindow_success

create_mainWindow_fail:

; Get the reason why CreateWindow request fail
; READ( socketX, @requestStatus, 32 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [requestStatus]
    mov    edx, 32
    int    0x80
; WRITE( _STDOUT_, @errmsg_createMainWindow, errmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_createMainWindow]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

create_mainWindow_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure the X Server is ready to receive the next request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; WRITE( socketX, @getWMDeleteMessage, 24 )
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

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLIN_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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
;   Make sure the X Server is ready to receive the next request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for systemcall poll
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
;   Request WM_PROTOCOLS atom property using InternAtom request.
;   We need the WM_PROTOCOLS atom property in order to apply the
;   WM_DELETE_WINDOW atom.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( socketX, @getWMProtocols, 20 )
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

; Setup parameters for systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLIN_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; READ( socketX, @InternAtom_reply, 32 )
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

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; Setup graphicContext structure
    mov    eax, [XServer.ridBase]
    add    eax, 1
    mov    ebx, [mainWindow.wid]
    mov    [graphicContext.cid], eax
    mov    [graphicContext.drawable], ebx

; WRITE( socketX, @graphicContext, 16 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [graphicContext]
    mov    edx, 16
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load the "24bit_testimage.bmp" image file and initialize the
;   putImage structure.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; testimage_fd = OPEN( @path_testimage, _O_RDONLY_ )
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [path_testimage]
    mov    ecx, _O_RDONLY_
    int    0x80
    test   eax, eax
    js     testimage_open_fail
    jmp    testimage_open_success

testimage_open_fail:

; WRITE( _STDOUT_, @errmsg_testimageOpen, errmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [errmsg_testimageOpen]
    mov    edx, [errmsg_len]
    int    0x80
    jmp    exit_failure

testimage_open_success:

    mov    [testimage_fd], eax

; Seek to the offset 0x8a, which contains data pixels.
; LSEEK( testimage_fd, 0x8a, _SEEK_SET_ )
    mov    eax, _SYSCALL_LSEEK_
    mov    ebx, [testimage_fd]
    mov    ecx, 0x8a
    mov    edx, _SEEK_SET_
    int    0x80

; READ( testimage_fd, @temporary_dataPixel, 262144 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [testimage_fd]
    lea    ecx, [temporary_dataPixel]
    mov    edx, 262144
    int    0x80

; CLOSE( testimage_fd )
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [testimage_fd]
    int    0x80

; Initialize putImage structure
    mov    eax, [mainWindow.wid]
    mov    ebx, [graphicContext.cid]
    mov    [putImage.drawable], eax
    mov    [putImage.gc], ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fix testimage_pixelData byte order (convert ABRG to RGBA).
;   The byte order in .bmp image file usually in format ABRG, but
;   the format needed by the X Server is RGBA.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Initialize the loop
    mov    ecx, 128
    lea    esi, [temporary_dataPixel]
    lea    edi, [testimage_dataPixel]
    mov    ebx, esi
    add    esi, (65536 - (128*4))
    xor    eax, eax

loop_fix_testimage:

    mov    al, [esi+2]    ;al = temporary_dataPixel[ Red Channel ]
    mov    [edi  ], al    ;testimage_dataPixel[ Red Channel ] = al

    mov    al, [esi+3]    ;al = temporary_dataPixel[ Green Channel ]
    mov    [edi+1], al    ;testimage_dataPixel[ Green Channel ] = al

    mov    al, [esi+1]    ;al = temporary_dataPixel[ Blue Channel ]
    mov    [edi+2], al    ;testimage_dataPixel[ Blue Channel ] = al

    add    esi, 4
    add    edi, 4

    sub    ecx, 1
    jnz    loop_fix_testimage

endloop_fix_testimage:

    mov    ecx, 128
    sub    esi, ((128*4) + (128*4))
    cmp    esi, ebx
    jge    loop_fix_testimage


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Make sure the X Server is ready to receive the next request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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
; Setup setWindowDeleteMsg structure
    mov    [setWindowDeleteMsg.window], eax
    mov    [setWindowDeleteMsg.data], ebx
    mov    [setWindowDeleteMsg.property], ecx
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
;   Make sure the X Server is ready to receive the next request.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; Setup mapWindow structure
    mov    eax, [mainWindow.wid]
    mov    [mapWindow.wid], eax

; WRITE( socketX, @mapWindow, 8 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [mapWindow]
    mov    edx, 8
    int    0x80




mainloop:




;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Wait for events from the X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Setup parameters for the systemcall poll
    mov    eax, [socketX]
    mov    ebx, _POLLIN_
    mov    [poll.fd], eax
    mov    [poll.events], bx

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; READ( socketX, @XEventReply, 1 )
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
;                         XEvent Functions
;
;
;
; ####################################################################

%include "XEventFunc_KeyPress.asm"
%include "XEventFunc_KeyRelease.asm"
%include "XEventFunc_ButtonPress.asm"
%include "XEventFunc_ButtonRelease.asm"
%include "XEventFunc_MotionNotify.asm"
%include "XEventFunc_EnterNotify.asm"
%include "XEventFunc_LeaveNotify.asm"
%include "XEventFunc_FocusIn.asm"
%include "XEventFunc_FocusOut.asm"
%include "XEventFunc_KeymapNotify.asm"
%include "XEventFunc_Expose.asm"
%include "XEventFunc_GraphicsExposure.asm"
%include "XEventFunc_NoExposure.asm"
%include "XEventFunc_VisibilityNotify.asm"
%include "XEventFunc_CreateNotify.asm"
%include "XEventFunc_DestroyNotify.asm"
%include "XEventFunc_UnmapNotify.asm"
%include "XEventFunc_MapNotify.asm"
%include "XEventFunc_MapRequest.asm"
%include "XEventFunc_ReparentNotify.asm"
%include "XEventFunc_ConfigureNotify.asm"
%include "XEventFunc_ConfigureRequest.asm"
%include "XEventFunc_GravityNotify.asm"
%include "XEventFunc_ResizeRequest.asm"
%include "XEventFunc_CirculateNotify.asm"
%include "XEventFunc_CirculateRequest.asm"
%include "XEventFunc_PropertyNotify.asm"
%include "XEventFunc_SelectionClear.asm"
%include "XEventFunc_SelectionRequest.asm"
%include "XEventFunc_SelectionNotify.asm"
%include "XEventFunc_ColormapNotify.asm"
%include "XEventFunc_MappingNotify.asm"
%include "XEventFunc_ClientMessage.asm"
