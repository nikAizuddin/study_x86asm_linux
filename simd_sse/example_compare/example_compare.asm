;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                  Example using SSE instructions
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 01-MAC-2015
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

    align 16, db 0
    Pixel1:
        .b:        dd 4.0
        .g:        dd 9.0
        .r:        dd 4.0
        .a:        dd 4.0

    align 16, db 0
    Pixel2:
        .b:        dd 6.0
        .g:        dd 6.0
        .r:        dd 6.0
        .a:        dd 6.0

section .text

_start:

    movdqa  xmm0, [Pixel1]
    movdqa  xmm1, [Pixel2]
    ucomiss xmm0, xmm1 ;compare .b only because scalar

    jb     B
A:
    mov    eax, 0x01
    jmp    END
B:
    mov    eax, 0x02
END:

align 16, nop
exit_success:

    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx
    int    0x80
