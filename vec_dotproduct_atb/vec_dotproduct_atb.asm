;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            Transpose of vector A dot product vector B
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 09-APR-2015
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
%include "include/constants.inc"
%include "include/data.inc"

global _start

section .text

_start:

    mov    ecx, NUM_OF_ELEMENTS
    lea    esi, [A]
    lea    edi, [B]
    pxor   xmm0, xmm0

loop_dotproduct:

    movss  xmm1, [esi]
    movss  xmm2, [edi]

    mulss  xmm1, xmm2
    addss  xmm0, xmm1

    add    esi, ELEMENTSIZE
    add    edi, ELEMENTSIZE

    sub    ecx, 1
    jnz    loop_dotproduct

endloop_dotproduct:

    movss  [C], xmm0

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
