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
        .b:        db 4
        .g:        db 8
        .r:        db 12
        .a:        db 16

    align 16, db 0
    meanDivisor:
        .b:        dd 2.0
        .g:        dd 2.0
        .r:        dd 2.0
        .a:        dd 2.0

section .text

_start:

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Load source pixel
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    movd   xmm0, [srcPixel]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert 32bit integer to single precision, saved to XMM0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    punpcklbw xmm0, xmm7
    punpcklwd xmm0, xmm7
    cvtdq2ps xmm0, xmm0 ;dword int to single-precision


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save to savedPixel
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    movdqa [savedPixel], xmm0


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Write savedPixel to dstPixel
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    movdqa xmm0, [savedPixel]
    cvtps2dq xmm0, xmm0
    packssdw xmm0, xmm7
    packuswb xmm0, xmm7

    movd   [dstPixel], xmm0


align 16, nop
exit_success:

    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx
    int    0x80
