;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                Example using MMX EMMS instruction
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

section .bss 

    align 16, resb 1
    savedPixel:
        .b:        resd 1
        .g:        resd 1
        .r:        resd 1
        .a:        resd 1

    align 16, resb 1
    dstPixel:
        .b:        resb 1
        .g:        resb 1
        .r:        resb 1
        .a:        resb 1

section .data

    align 16, db 0
    srcPixel:
        .b:        dd 4.0
        .g:        dd 8.0
        .r:        dd 12.0
        .a:        dd 16.0

    align 16, db 0
    meanDivisor:
        .b:        dd 2.0
        .g:        dd 2.0
        .r:        dd 2.0
        .a:        dd 2.0

section .text

_start:

    movdqa   xmm0, [srcPixel]
    rsqrtps  xmm0, xmm0
b:

align 16, nop
exit_success:

    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx
    int    0x80
