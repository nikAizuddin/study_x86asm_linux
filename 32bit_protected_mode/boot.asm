;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;           Entering 32-bit protected mode during boot
;
;          This source file is based on a tutorial from:
;       http://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/
;            lectures/os-dev.pdf
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 16-JAN-2014
;
;       LANGUAGE: 16-Bit Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: ---
;         KERNEL: ---
;         FORMAT: BIN
;
;=====================================================================

[org 0x7c00]

    mov    bp, 0x9000
    mov    sp, bp

    call   switch_to_pm

    jmp    $

%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 32]
BEGIN_PM:
    mov    ebx, MSG_PROT_MODE
    call   print_string_pm

    jmp $

MSG_REAL_MODE: db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE: db "Successfully landed in 32-bit Protected Mode", 0

times 510-($-$$) db 0
dw 0xaa55
