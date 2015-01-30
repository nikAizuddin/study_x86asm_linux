;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                  File operation (Write a file)
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

    file_handle:    resd 1

section .rodata

    wb:          db "Oyeah! ", 0xa
    wb_length:   dd 8
    filename:    db "text_file.txt",0

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Open file as write-only,
;   create the file if not exists, and
;   append data to the end of file.
;
;   001:   OPEN( @filename, 0q2101, 0q644 );
;   002:   if EAX is negative, goto exit_failure;
;   003:   file_handle = EAX;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 5                   ;systemcall open
    lea    ebx, [filename]
    xor    ecx, 0q2101              ;read-only
    mov    edx, 0q644               ;file permission
    int    0x80

    test   eax, eax
    js     exit_failure

    mov    [file_handle], eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   WRITE( file_handle, @wb, wb_length );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    mov    eax, 4                   ;systemcall write
    mov    ebx, [file_handle]
    lea    ecx, [wb]
    mov    edx, [wb_length]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;          exit_success:
;   005:       CLOSE( @file_handle );
;   006:       EXIT( 0 );
;          exit_failure:
;   007:       EXIT( -1 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit_success:
    mov    eax, 6                   ;systemcall close
    lea    ebx, [file_handle]
    int    0x80

    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80

exit_failure:
    mov    eax, 0x01                ;systemcall exit
    mov    ebx, -1                  ;return -1
    int    0x80
