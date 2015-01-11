;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                     Simple string operation
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 11-JAN-2015
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

    output_string: resd 6

section .data

    input_string: db "Netwide Assembler"

section .text

_start:


;
;
;   ESI is Extended Source Index.
;   EDI is Extended Destination Index.
;
;   Do not confuse between MOV and LEA instructions.
;       MOV = Get the value from the memory address.
;       LEA = Get the memory address.
;
;
    lea esi, [input_string]         ;ESI = address input_string
    lea edi, [output_string]        ;EDI = address output_string


;
;
;   If the Direction Flag (in EFLAGS register) is 0,
;   the ESI and EDI registers are incremented each time the
;   instruction movsb, movsw, or movsd are called.
;
;   But if the Direction Flag is = 1, the ESI and EDI registers
;   are decremented instead.
;
;   The instructions that changes Direction Flag:
;       cld = clear Direction Flag (Direction Flag = 0)
;       std = set Direction Flag (Direction Flag = 1)
;
;
    cld                             ;make sure Direction Flag = 0
    movsb                           ;copy 1 byte from [ESI] to [EDI]
    movsw                           ;copy 2 bytes from [ESI] to [EDI]
    movsd                           ;copy 4 bytes from [ESI] to [EDI]


.exit:
    mov    eax, 0x01                ;system call exit
    mov    ebx, 0x00                ;return 0
    int    0x80
