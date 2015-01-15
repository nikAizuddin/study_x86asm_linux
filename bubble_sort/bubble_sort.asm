;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                      Bubble Sort algorithm
;
;     Let A = array containing integer numbers,
;         N = number of elements in array,
;
;          begin
;     001:     I = (N - 1) * 4;
;
;              .loop:
;
;     002:         J = I;
;
;                  .subloop:
;     003:             offset = I - J;
;     004:             ptr1 = A + offset;
;     005:             ptr2 = A + offset + 4;
;     006:             if ptr1^ < ptr2^, goto .dont_swap;
;                      .swap:
;     007:                 temp  = ptr1^;
;     008:                 ptr1^ = ptr2^;
;     009:                 ptr2^ = temp;
;                      .dont_swap:
;     010:             J = J - 4;
;     011:             if J != 0, then
;                          goto .subloop;
;                  .endsubloop:
;
;     012:         I = I - 4;
;     013:         if I != 0, goto .loop;
;
;              .endloop:
;          end.
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

    offset    resd 1
    ptr1      resd 1
    ptr2      resd 1
    temp      resd 1
    I         resd 1
    J         resd 1

section .data

    A:    dd 9, 3, 4, 2, 1, 7, 6, 5, 9, 8
    N:    dd 10

section .text

_start:


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001: I = (N - 1) * 4;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [N]
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx
    mov    [I], eax


.loop:


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002: J = I;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [I]
    mov    [J], eax


.subloop:


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003: offset = I - J;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [I]
    mov    ebx, [J]
    sub    eax, ebx
    mov    [offset], eax


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004: ptr1 = @A + offset;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    eax, [A]
    mov    ebx, [offset]
    add    eax, ebx
    mov    [ptr1], eax


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005: ptr2 = @A + offset + 4;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    eax, [A]
    mov    ebx, [offset]
    add    eax, ebx
    add    eax, 4
    mov    [ptr2], eax


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006: if ptr1^ < ptr2^, goto .dont_swap;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [ptr1]
    mov    eax, [eax]
    mov    ebx, [ptr2]
    mov    ebx, [ebx]
    cmp    eax, ebx
    jb     .dont_swap


.swap:


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007: temp = ptr1^;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [ptr1]
    mov    eax, [eax]
    mov    [temp], eax


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008: ptr1^ = ptr2^;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [ptr1]
    mov    ebx, [ptr2]
    mov    ebx, [ebx]
    mov    [eax], ebx


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009: ptr2^ = temp;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [temp]
    mov    ebx, [ptr2]
    mov    [ebx], eax


.dont_swap:


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010: J = J - 4;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [J]
    sub    eax, 4
    mov    [J], eax


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011: if J != 0, then goto .subloop;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [J]
    cmp    eax, 0
    jne    .subloop


.endsubloop:


; 
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012: I = I - 4;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [I]
    sub    eax, 4
    mov    [I], eax


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013: if I != 0, goto .loop;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [I]
    cmp    eax, 0
    jne    .loop


.endloop:


;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   In GDB, break the program here, and run command:
;
;   (gdb) x/10d &A
;
;   to see the result. Now, the array A has been sorted.
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
