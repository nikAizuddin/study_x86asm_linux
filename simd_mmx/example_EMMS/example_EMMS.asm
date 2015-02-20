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

section .data

    pixel:
        .red:      db 100
        .green:    db 75
        .blue:     db 25
        .alpha:    db 255

section .text

_start:

;When the program starts, the values of ST0 is 0x0
;and FTAG is 0xffff.

;Lets try to load some data into MM0 register.

    movd   mm0, [pixel]

;At this point, some x87 FPU registers have changed:
;ST0 changes from 0x00000000000000000000 to 0xffff00000000ff194b64
;FTAG changes from 0xffff to 0x5556

;Lets try to execute EMMS instruction.

    emms

;At this point, FTAG is restored back to 0xffff.

exit_success:

    mov    eax, _SYSCALL_EXIT_
    xor    ebx, ebx
    int    0x80
