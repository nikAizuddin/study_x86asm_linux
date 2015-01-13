;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;   Example using brk() system call for dynamic memory allocations.
;
;   DON'T CONFUSE!
;       brk() used in C Function is different with brk()
;       systemcall (systemcall 45 for Linux x86 ASM).
;
;   In C program brk() returns -1 if failed. But brk() systemcall
;   (the systemcall 45), returns the current break address if failed.
;
;   In C program when brk() success, it returns 0. But, brk()
;   systemcall returns the new break address if success.
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 13-OCT-2014
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: i386
;         KERNEL: Linux 32-bit
;         FORMAT: ELF32
;
;=====================================================================

extern etext ;address of the end of the text segment.
extern edata ;address of the end of the initialized data segment.
extern end   ;address of the end of the uninitialized (bss segm.).

;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Those externs, etext, edata, end, have nothing to do with brk().
;   But I include them in case if we need to know the address of
;   etext, edata, and end.
;
;   In gdb, type "x/x etext", "x/x edata", "x/x end" to check the
;   address of etext, edata, and end.
;
;   For more information about etext, edata, and end, open your
;   terminal and run the command "$ man 3 end".
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;

global _start

section .bss

    initial_break: resd 1

    current_break: resd 1

    new_break: resd 1

section .text

_start:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   About brk() system call, please read only at "LINUX NOTES" in
;   "$ man 2 brk" manpage, because brk() in C Function is different
;   with brk() in systemcall.
;
;   As it says, the brk() system call returns current break address
;   if failed. If success, brk() returns new break address.
;
;   To get the current break address, pass any value that makes this
;   system call failed.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get current break address
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, 45                  ;system call brk
    mov    ebx, 0                   ;invalid address
    int    0x80

    mov    [current_break], eax
    mov    [initial_break], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Break the program here in GDB. Open terminal, and run command
;   "$ top". Watch the memory used by this program, and remember it.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;


.b1:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Allocate 8 bytes of heap memory
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, 45                  ;system call brk
    mov    ebx, [current_break]
    add    ebx, 8                   ;allocate 8 bytes
    int    0x80

    mov    [new_break], eax
    mov    [current_break], eax


.b2:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Break the program here in GDB. You'll see the memory used by
;   the program has increased by 8 bytes.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Allocate another 67108864 bytes of heap memory
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, 45                  ;system call brk
    mov    ebx, [current_break]
    add    ebx, 67108864            ;allocate 67108864 bytes
    int    0x80

    mov    [new_break], eax
    mov    [current_break], eax




;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Break the program here in GDB. You'll noticed the memory
;   used by the program has increased to 65688kb.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;


.b3:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Free allocated heap memory
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, 45                  ;system call brk
    mov    ebx, [initial_break]     ;reset break address initial addr
    int    0x80

    mov    [new_break], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Break the program here in GDB, to see the memory drop from
;   65688kb to 148kb.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;


.b4:


.exit:
    mov    eax, 0x01                ;system call exit
    mov    ebx, 0x00                ;return 0
    int    0x80
