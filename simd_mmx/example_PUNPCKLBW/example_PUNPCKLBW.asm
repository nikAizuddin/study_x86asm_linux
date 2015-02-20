;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;              Example using MMX PUNPCKLBW instruction
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 18-FEB-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

_SYSCALL_EXIT_    equ 1

global _start

section .data

    pixel1:
        .red:      db 100
        .green:    db 75
        .blue:     db 25
        .alpha:    db 255

    pixel2:
        .red:      db 212
        .green:    db 103
        .blue:     db 20
        .alpha:    db 255

section .text

_start:

    movd   mm1, [pixel1]
    movd   mm2, [pixel2]

    pxor         mm0, mm0
    punpcklbw    mm1, mm0
    punpcklbw    mm2, mm0

    paddw  mm3, mm1
    paddw  mm3, mm2

exit_success:

    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx
    int    0x80
