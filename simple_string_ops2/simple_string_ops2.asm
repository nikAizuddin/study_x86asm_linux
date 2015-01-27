;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                 Another simple string operation
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 20-JAN-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: i386
;         KERNEL: Linux 32-bit
;         FORMAT: ELF32
;
;=====================================================================

global _start

section .bss

    outstring: resd 1

section .data

    instring: db "Netwide Assembler"

section .text

_start:


    lea    esi, [instring]
    lea    edi, [outstring]

    cld
    lodsb
    mov    [edi], al
    add    edi, 1
    lodsb
    mov    [edi], al
    add    edi, 1

exit:
    mov    eax, 0x01                ;system call exit
    mov    ebx, 0x00                ;return 0
    int    0x80
