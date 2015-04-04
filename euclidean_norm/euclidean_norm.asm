;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;               Calculate Euclidean Norm of a vector
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 04-APR-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

;Include constant symbols and global variables
%include "constants.inc"
%include "data.inc"

global _start

section .text

_start:

    mov    ecx, NUM_OF_COLUMNS
    lea    esi, [X]
    pxor   xmm2, xmm2
    movss  xmm1, [T]           ;XMM1 = sign remover

loop:

    movss  xmm0, [esi]         ;XMM0 = X[ecx]
    andps  xmm0, xmm1          ;XMM0 = |XMM0|
    mulss  xmm0, xmm0          ;pow(XMM0,2)
    addss  xmm2, xmm0          ;XMM2 += XMM0

    add    esi, COLUMNSIZE

    sub    ecx, 1
    jnz    loop

endloop:

    sqrtss xmm2, xmm2          ;sqrt(XMM2)
    movss  [Y], xmm2           ;store final result into Y

b:
    ; Break the program here to see the result in Y.
    ; Use GDB Debugger to see the value in Y:
    ;     (gdb) break b
    ;     (gdb) run
    ;     (gdb) x/fw &Y
    ; The value of should be: 108.315712


exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
