;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;              Simple Example of Binary Coded Decimal
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 15-JAN-2015
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

    decimal:        rest 1          ;Reserve 1 tword

section .rodata

    hexadecimal:    dd 4294967295, 0

section .text

_start:


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert hexadecimal 0xffffffff to decimal 4294967295.
;
;   Note that I declared "hexadecimal" as "dd 4294967295, 0". I put
;   an extra 32-bit zeroes because I have to push the "hexadecimal"
;   value as 64-bit to the FPU stack.
;
;   If I push 32-bit to FPU stack, the FPU will treat "hexadecimal"
;   as signed integer. So, I push 64-bit so that FPU will treat it
;   as unsigned integer.
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    finit                           ;initialize FPU stack
    fild   qword [hexadecimal]      ;push hexadecimal to FPU stack
    fbstp  [decimal]                ;convert to BCD and store to mem


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Break the program here in GDB, and run this command:
;
;       (gdb) x/2x &decimal
;
;   to see the result. You will see that the program have converted
;   the 0xffffffff to 0x4294967295.
;
;   You must be thinking what to do with this 0x4294967295 number.
;   The purpose of converting to decimal number, is to print this
;   number to stdout.
;
;   Before printing, first we have to convert the decimal number
;   to ASCII characters, so that it will print properly to stdout.
;
;   So, here we just simply reverse the decimal number from
;   0x4294967295 to 0x5927694924, and then add each with 0x30 so
;   that it will become 0x35393237363934393234 (ASCII characters).
;
;   Goodluck :)
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
