;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                  File operation (Read a file)
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 30-JAN-2015
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

    rb:             resd 4
    rb_length:      resd 1
    file_handle:    resd 1

section .rodata

    filename:    db "text_file.txt",0

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Open file as read-only
;
;   001:   OPEN( @filename, 0q0, 0q644 );
;   002:   if EAX is negative, goto exit_failure;
;   003:   file_handle = EAX;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 5                   ;systemcall open
    lea    ebx, [filename]
    xor    ecx, ecx                 ;read-only
    mov    edx, 0q644               ;file permission
    int    0x80

    test   eax, eax
    js     exit_failure

    mov    [file_handle], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   READ( file_handle, @rb, 12 );
;   005:   rb_length = EAX;
;   006:   WRITE( stdout, @rb, rb_length );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 3                   ;systemcall read
    mov    ebx, [file_handle]
    lea    ecx, [rb]
    mov    edx, 12
    int    0x80
    mov    [rb_length], eax

    mov    eax, 4                   ;systemcall write
    mov    ebx, 1                   ;stdout
    lea    ecx, [rb]
    mov    edx, [rb_length]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          exit_success:
;   007:       CLOSE( file_handle );
;   008:       EXIT( 0 );
;          exit_failure:
;   009:       EXIT( -1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit_success:
    mov    eax, 6                   ;systemcall close
    mov    ebx, [file_handle]
    int    0x80

    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80

exit_failure:
    mov    eax, 0x01                ;systemcall exit
    mov    ebx, -1                  ;return -1
    int    0x80
