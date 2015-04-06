;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                  QR Decomposition of a matrix
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 06-APR-2015
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

extern euclidean_norm
global _start

section .text

_start:


;Check make sure matrix A is properly set.
    lea    esi, [A]
    mov    ecx, (4*4)
loop_test:
    movss  xmm0, [esi]
    add    esi, 4
    sub    ecx, 1
    jnz    loop_test
endloop_test:


;Find Q



exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
