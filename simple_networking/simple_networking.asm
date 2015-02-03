;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;         Simple networking, for example download a webpage
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 31-JAN-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

global _start

section .bss

    socket:            resd 1

    webpage:
        .str:          resd 512
        .len:          resd 1

section .rodata

    socket_create:
        .domain:       dd 2                ;PF_INET
        .type:         dd 1                ;SOCK_STREAM
        .protocol:     dd 6                ;IPPROTO_TCP

    server_addr:
        .family:       dw 2                ;AF_INET
        .port:         dw 0x5000           ;PORT 80
        .ip:           db 198,35,26,96     ;www.wikipedia.org ip-addr
        .padding:      dd 0

    request:
        .str:          db "GET / HTTP/1.0", 0x0d, 0x0a
                       db "Host: www.wikipedia.org", 0x0d, 0x0a
                       db "User-Agent: HTMLGET 1.0", 0x0d,0x0a
                       db 0x0d,0x0a,0x00
        .len:          dd 70               ;length of request.str

section .data

    connect:
        .socketfd:     dd 0
        .addr:         dd server_addr
        .addrlen:      dd 16               ;sizeof server_addr

    send:
        .socketfd:     dd 0
        .addr:         dd request.str
        .addrlen:      dd 70               ;make sure = request.len
        .flags:        dd 0

    receive:
        .socketfd:     dd 0
        .addr:         dd webpage.str
        .addrlen:      dd 2048
        .flags:        dd 0

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   SOCKETCALL( 1, @socket_create );
;   002:   if EAX is negative, goto socket_create_fail
;   003:   goto socket_create_success;
;          socket_create_fail:
;   004:       goto exit_failure;
;          socket_create_success:
;   005:   socket = EAX;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 102                 ;systemcall socketcall
    mov    ebx, 1                   ;create socket
    lea    ecx, [socket_create]
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
;   006:   connect.socketfd = socket;
;   007:   SOCKETCALL( 3, @connect );
;   008:   if EAX is negative, goto socket_connect_fail;
;   009:   goto socket_connect_success;
;          socket_connect_fail:
;   010:       goto exit_failure;
;          socket_connect_success:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    mov    [connect.socketfd], eax

    mov    eax, 102                 ;systemcall socketcall
    mov    ebx, 3                   ;connect
    lea    ecx, [connect]
    int    0x80

    test   eax, eax
    js     socket_connect_fail
    jmp    socket_connect_success

socket_connect_fail:
    jmp    exit_failure
socket_connect_success:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   send.socketfd = socket;
;   012:   SOCKETCALL( 9, @send );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    mov    [send.socketfd], eax

    mov    eax, 102                 ;systemcall socketcall
    mov    ebx, 9                   ;send
    lea    ecx, [send]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   receive.socketfd = socket;
;          loop_receive:
;   014:       webpage.len = SOCKETCALL( 10, @receive );
;   015:       if EAX == 0, goto endloop_receive;
;   016:       WRITE( stdout, @webpage.str, webpage.len );
;   017:       goto .loop_receive;
;          endloop_receive:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [socket]
    mov    [receive.socketfd], eax

loop_receive:
    mov    eax, 102                 ;systemcall socketcall
    mov    ebx, 10                  ;recv
    lea    ecx, [receive]
    int    0x80
    mov    [webpage.len], eax

    test   eax, eax
    jz     endloop_receive

    mov    eax, 4                   ;systemcall write
    mov    ebx, 1                   ;stdout
    lea    ecx, [webpage.str]
    mov    edx, [webpage.len]
    int    0x80

    jmp    loop_receive
endloop_receive:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          exit_success:
;   018:       CLOSE( socket );
;   019:       EXIT(0);
;          exit_failure:
;   020:       EXIT(-1);
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit_success:
    mov    eax, 6                   ;systemcall close
    mov    ebx, [socket]
    int    0x80

    mov    eax, 1                   ;systemcall exit
    mov    ebx, 0                   ;exit status 0
    int    0x80

exit_failure:
    mov    eax, 1                   ;systemcall exit
    mov    ebx, -1                  ;exit status -1
    int    0x80
