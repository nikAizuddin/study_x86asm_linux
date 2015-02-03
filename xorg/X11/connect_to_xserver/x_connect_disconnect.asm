;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                      Connect to X Server
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 29-JAN-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

%define    _F_OK_                   0
%define    _X_OK_                   1
%define    _W_OK_                   2
%define    _R_OK_                   4
%define    _O_RDONLY_               0q0
%define    _O_RDWR_                 0q2
%define    _O_NONBLOCK_             0q4000
%define    _PF_LOCAL_               1
%define    _AF_LOCAL_               1
%define    _IPPROTO_IP_             0
%define    _F_GETFL_                3
%define    _F_SETFL_                4
%define    _F_SETFD_                2
%define    _FD_CLOEXEC_             1
%define    _POLLIN_                 0x001
%define    _POLLOUT_                0x004
%define    _SOCK_STREAM_            1
%define    _SYSCALL_EXIT_           1
%define    _SYSCALL_SOCKET_         1
%define    _SYSCALL_CONNECT_        3
%define    _SYSCALL_READ_           3
%define    _SYSCALL_OPEN_           5
%define    _SYSCALL_CLOSE_          6
%define    _SYSCALL_GETSOCKNAME_    6
%define    _SYSCALL_GETPEERNAME_    7
%define    _SYSCALL_ACCESS_         33
%define    _SYSCALL_SOCKETCALL_     102
%define    _SYSCALL_UNAME_          122
%define    _SYSCALL_WRITEV_         146
%define    _SYSCALL_POLL_           168
%define    _SYSCALL_FSTAT64_        197
%define    _SYSCALL_FCNTL64_        221

global _start

section .bss

    socket:                  resd 1

    args:
        .param1:             resd 1
        .param2:             resd 1
        .param3:             resd 1

    kernel_info:             resd 128

    xauth_fd:                resd 1

    xauth_fstat:
        .st_dev:             resd 2
        .padding0:           resd 1
        .st_ino:             resd 1
        .st_mode:            resd 1
        .st_nlink:           resd 1
        .st_uid:             resd 1
        .st_gid:             resd 1
        .padding1:           resd 1
        .padding2:           resd 1
        .padding3:           resd 1
        .st_size:            resd 2
        .st_blksize:         resd 1
        .st_blocks:          resd 2
        .st_atime:           resd 2
        .st_mtime:           resd 2
        .st_ctime:           resd 2

    xauth_data:              resd 1024

    pollfd:
        .fd:                 resd 1
        .events:             resw 1
        .revents:            resw 1

    writebuffer1:            resd 128
    writebuffer2:            resd 128
    writebuffer3:            resd 128

    writev:
        .buffer1:            resd 1
        .buffer1_len:        resd 1
        .buffer2:            resd 1
        .buffer2_len:        resd 1
        .buffer3:            resd 1
        .buffer3_len:        resd 1
        .buffer4:            resd 1
        .buffer4_len:        resd 1

section .data

    xserver:
        .family:             dw 1          ;AF_LOCAL
        .path:               db "/tmp/.X11-unix/X0",0

    xserver_len:             dd 20

    xauth_file:              db "/var/run/lightdm/nlck/xauthority",0

    socketname:
        .family:             dw _AF_LOCAL_
        .data:               dd 0,0,0,0
    socketname_len:          dd 2

    timeout:                 dd 300 ;default=4294967295

    auth_request:
        .byteOrder:          db 0x6c
        .pad0:               db 0
        .majorVersion:       dw 11
        .minorVersion:       dw 0
        .nbytesAuthProto:    dw 0
        .nbytesAuthStr:      dw 0
        .pad1:               db 0
        .pad2:               db 0
    auth_request_len:        dd 12

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Create socket
;   ???:   args.param1 = _PF_LOCAL_;    ##Protocol Family
;   ???:   args.param2 = _SOCK_STREAM_; ##Socket type
;   ???:   args.param3 = _IPPROTO_IP_;  ##Protocol
;   ???:   SOCKETCALL( _SYSCALL_SOCKET_ , @args );
;   ???:   if EAX is negative, goto socket_create_fail;
;   ???:   goto socket_create_success;
;          socket_create_fail:
;   ???:       goto exit_failure;
;          socket_create_success:
;   ???:       socket = EAX;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [args.param1], _PF_LOCAL_
    mov    dword [args.param2], _SOCK_STREAM_
    mov    dword [args.param3], _IPPROTO_IP_

    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _SYSCALL_SOCKET_
    lea    ecx, [args]
    int    0x80

    test   eax, eax
    js     socket_create_fail
    jmp    socket_create_success

socket_create_fail:
    jmp    exit_failure
socket_create_success:
    mov    [socket], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Connect to the X Server
;   ???:   args.param1 = socket;     ##Socketfd
;   ???:   args.param2 = @xserver;   ##Address
;   ???:   args.param3 = 20;         ##Length of the Address
;   ???:   SOCKETCALL( _SYSCALL_CONNECT_ , @args );
;   ???:   if EAX is negative, goto socket_connect_fail;
;   ???:   goto socket_connect_success;
;          socket_connect_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          socket_connect_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    lea    ebx, [xserver]
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    dword [args.param3], 20

    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _SYSCALL_CONNECT_
    lea    ecx, [args]
    int    0x80

    test   eax, eax
    js     socket_connect_fail
    jmp    socket_connect_success

socket_connect_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
socket_connect_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Get peer name
;   ???:   args.param1 = socket;       ##Socketfd = socket
;   ???:   args.param2 = @xserver;     ##Address
;   ???:   args.param3 = @xserver_len; ##Length of the Address
;   ???:   SOCKETCALL( _SYSCALL_GETPEERNAME_ , @args );
;   ???:   if EAX is negative, goto getpeername_fail;
;   ???:   goto getpeername_success;
;          getpeername_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          getpeername_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    lea    ebx, [xserver]
    lea    ecx, [xserver_len]
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    [args.param3], ecx

    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _SYSCALL_GETPEERNAME_
    lea    ecx, [args]
    int    0x80

    test   eax, eax
    js     getpeername_fail
    jmp    getpeername_success

getpeername_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
getpeername_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Get kernel name and information
;   ???:   UNAME( @kernel_info );
;   ???:   if EAX is negative, goto uname_fail;
;   ???:   goto uname_success;
;          uname_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          uname_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_UNAME_
    lea    ebx, [kernel_info]
    int    0x80

    test   eax, eax
    js     uname_fail
    jmp    uname_success

uname_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
uname_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Check permission to access Xauthority file
;   ???:   ACCESS( @xauth_file, _R_OK_ );
;   ???:   if EAX is negative, goto access_xauth_fail;
;   ???:   goto access_xauth_success;
;          access_xauth_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          access_xauth_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_ACCESS_
    lea    ebx, [xauth_file]
    mov    ecx, _R_OK_
    int    0x80

    test   eax, eax
    js     access_xauth_fail
    jmp    access_xauth_success

access_xauth_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
access_xauth_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Open the Xauthority file
;   ???:   OPEN( @xauth_file, _O_RDONLY );
;   ???:   if EAX is negative, goto open_xauth_file;
;   ???:   goto open_xauth_success;
;          open_xauth_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          open_xauth_success:
;   ???:       xauth_fd = EAX;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_OPEN_
    lea    ebx, [xauth_file]
    mov    ecx, _O_RDONLY_
    int    0x80

    test   eax, eax
    js     open_xauth_fail
    jmp    open_xauth_success

open_xauth_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
open_xauth_success:
    mov    [xauth_fd], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;           ## Get Xauthority file status
;  ???:     FSTAT64( xauth_fd, @xauth_fstat );
;  ???:     if EAX is negative, goto fstat64_xauth_fail;
;  ???:     goto fstat64_xauth_success;
;           fstat64_xauth_fail:
;  ???:         CLOSE( socket );
;  ???:         CLOSE( xauth_fd );
;  ???:         goto exit_failure;
;           fstat64_xauth_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_FSTAT64_
    mov    ebx, [xauth_fd]
    lea    ecx, [xauth_fstat]
    int    0x80

    test   eax, eax
    js     fstat64_xauth_fail
    jmp    fstat64_xauth_success

fstat64_xauth_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [xauth_fd]
    int    0x80
    jmp    exit_failure
fstat64_xauth_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Read Xauthority file
;   ???:   READ( xauth_fd, @xauth_data, 4096 );
;   ???:   if EAX is negative, goto read_xauth_fail;
;   ???:   goto read_xauth_success;
;          read_xauth_fail:
;   ???:       CLOSE( socket );
;   ???:       CLOSE( xauth_fd );
;   ???:       goto exit_failure;
;          read_xauth_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_READ_
    mov    ebx, [xauth_fd]
    lea    ecx, [xauth_data]
    mov    edx, 4096
    int    0x80

    test   eax, eax
    js     read_xauth_fail
    jmp    read_xauth_success

read_xauth_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [xauth_fd]
    int    0x80
    jmp    exit_failure
read_xauth_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   ???:   CLOSE( xauth_fd );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [xauth_fd]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Get Xserver socket name
;   ???:   args.param1 = socket;
;   ???:   args.param2 = @socketname;
;   ???:   args.param3 = @socketname_len;
;   ???:   SOCKETCALL( _SYSCALL_GETSOCKNAME_ , @args );
;   ???:   if EAX is negative, goto getsockname_fail;
;   ???:   goto getsockname_success;
;          getsockname_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          getsockname_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    lea    ebx, [socketname]
    lea    ecx, [socketname_len]
    mov    [args.param1], eax
    mov    [args.param2], ebx
    mov    [args.param3], ecx

    mov    eax, _SYSCALL_SOCKETCALL_
    mov    ebx, _SYSCALL_GETSOCKNAME_
    lea    ecx, [args]
    int    0x80

    test   eax, eax
    js     getsockname_fail
    jmp    getsockname_success

getsockname_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
getsockname_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Get socket access mode and status flag
;   ???:   FCNTL64( socket, _F_GETFL_ );
;   ???:   if EAX is negative, goto fcntl64_getstatus_fail;
;   ???:   goto fcntl64_getstatus_success;
;          fcntl64_getstatus_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          fcntl64_getstatus_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_FCNTL64_
    mov    ebx, [socket]
    mov    ecx, _F_GETFL_
    int    0x80

    test   eax, eax
    js     fcntl64_getstatus_fail
    jmp    fcntl64_getstatus_success

fcntl64_getstatus_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
fcntl64_getstatus_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Set socket non-blocking
;   ???:   FCNTL64( socket, _F_SETFL_, _O_RDWR | _O_NONBLOCK_ );
;   ???:   if EAX is negative, goto fcntl64_setflag_fail;
;   ???:   goto fcntl64_setflag_success;
;          fcntl64_setflag_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          fcntl64_setflag_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_FCNTL64_
    mov    ebx, [socket]
    mov    ecx, _F_SETFL_
    lea    edx, [_O_RDWR_ + _O_NONBLOCK_]
    int    0x80

    test   eax, eax
    js     fcntl64_setflag_fail
    jmp    fcntl64_setflag_success

fcntl64_setflag_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
fcntl64_setflag_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Set socket file descriptor flag
;   ???:   FCNTL64( socket, _F_SETFD_, _FD_CLOEXEC_ );
;   ???:   if EAX is negative, goto fcntl64_setfd_fail;
;   ???:   goto fcntl64_setfd_success;
;          fcntl64_setfd_fail:
;   ???:       CLOSE( socket );
;   ???:       goto exit_failure;
;          fcntl64_setfd_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, _SYSCALL_FCNTL64_
    mov    ebx, [socket]
    mov    ecx, _F_SETFD_
    mov    edx, _FD_CLOEXEC_
    int    0x80

    test   eax, eax
    js     fcntl64_setfd_fail
    jmp    fcntl64_setfd_success

fcntl64_setfd_fail:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    jmp    exit_failure
fcntl64_setfd_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Wait for the socket to become ready for I/O 
;   ???:   pollfd.fd = socket;
;   ???:   pollfd.events = _POLLIN_ | _POLLOUT_;
;   ???:   pollfd.revents = _POLLOUT_;
;   ???:   POLL( @pollfd, 1, timeout );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    lea    ebx, [_POLLIN_+ _POLLOUT_]
    mov    [pollfd.fd], eax
    mov    [pollfd.events], bx
    mov    word [pollfd.revents], _POLLOUT_

    mov    eax, _SYSCALL_POLL_
    lea    ebx, [pollfd]
    mov    ecx, 1
    mov    edx, [timeout]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Authenticate the connection
;   ???:   auth_request.nbytesAuthProto = xauth_data[18];
;   ???:   auth_request.nbytesAuthStr   = xauth_data[38];
;   ???:   writev.buffer1     = @auth_request;
;   ???:   writev.buffer1_len = auth_request_len;
;
;   ???:   writebuffer1       = xauth_data[19 ... 36];
;   ???:   writev.buffer2     = @writebuffer1;
;   ???:   writev.buffer2_len = 18; 
;
;   ???:   writev.buffer2     = @writebuffer2;
;   ???:   writev.buffer2_len = 2;
;
;   ???:   writebuffer3       = xauth_data[39 ... 54];
;   ???:   writev.buffer4     = @writebuffer3;
;   ???:   writev.buffer4_len = 16; 
;
;   ???:   WRITEV( socket, @writev, 4 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    xor    ebx, ebx
    mov    al, [xauth_data + 18]
    mov    bl, [xauth_data + 38]
    lea    ecx, [auth_request]
    mov    edx, [auth_request_len]
    mov    [auth_request.nbytesAuthProto], ax
    mov    [auth_request.nbytesAuthStr], bx
    mov    [writev.buffer1], ecx
    mov    [writev.buffer1_len], edx

    lea    esi, [xauth_data + 19]
    lea    edi, [writebuffer1]
    mov    ebx, edi
    xor    ecx, ecx
    xor    eax, eax
    mov    cx, [auth_request.nbytesAuthProto]
    mov    ax, cx
    rep    movsb
    mov    [writev.buffer2], ebx
    mov    [writev.buffer2_len], eax

    mov    dword [writev.buffer3], writebuffer2
    mov    dword [writev.buffer3_len], 2

    lea    esi, [xauth_data + 39]
    lea    edi, [writebuffer3]
    mov    ebx, edi
    xor    ecx, ecx
    xor    eax, eax
    mov    cx, [auth_request.nbytesAuthStr]
    mov    ax, cx
    rep    movsb
    mov    [writev.buffer4], ebx
    mov    [writev.buffer4_len], eax

    mov    eax, _SYSCALL_WRITEV_
    mov    ebx, [socket]
    lea    ecx, [writev]
    mov    edx, 4
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          ## Wait for the socket to become ready for input
;   ???:   pollfd.fd = socket;
;   ???:   pollfd.events = _POLLIN_
;   ???:   POLL( @pollfd, 1, timeout );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    mov    [pollfd.fd], eax
    mov    word [pollfd.events], _POLLIN_

    mov    eax, _SYSCALL_POLL_
    lea    ebx, [pollfd]
    mov    ecx, 1
    mov    edx, [timeout]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          exit_success:
;   ???:       CLOSE( socket );
;   ???:       EXIT( 0 );
;          exit_failure:
;   ???:       EXIT( -1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit_success:
    mov    eax, _SYSCALL_CLOSE_
    mov    ebx, [socket]
    int    0x80
    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx                 ;exit status 0
    int    0x80
exit_failure:
    mov    eax, _SYSCALL_EXIT_
    mov    ebx, -1                  ;exit status -1
    int    0x80
