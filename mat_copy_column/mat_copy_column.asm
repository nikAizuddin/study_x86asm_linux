;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                    Copy a column of a matrix
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
%include "include/constants.inc"
%include "include/data.inc"

global _start

section .text

_start:

; In this example, we will copy a column of data, from
; the 3rd column of matrix A, into the 2nd column of matrix B.

    lea    esi, [A + (2*COLUMNSIZE)]
    lea    edi, [B + (1*COLUMNSIZE)]
    mov    ecx, 3

loop_copy_column:

    movss  xmm0, [esi]         ;XMM0 = A[:,2]
    movss  [edi], xmm0         ;B[:,1] = XMM0

    add    esi, ROWSIZE        ;point ESI to next row
    add    edi, ROWSIZE        ;point EDI to next row

    sub    ecx, 1
    jnz    loop_copy_column

endloop_copy_column:

exit:
    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
