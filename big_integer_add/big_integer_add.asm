;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                      Big integer addition
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 29-JAN-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

global _start

section .bss

    z:    resd 8

section .rodata

    p:    dd 0x04050903, 0x02080307, 0x01000409, 0,0,0,0,0
    q:    dd 0x05000007, 0x00000000, 0x09000001, 0,0,0,0,0
    base: dd 10

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   EBX = @z; 
;   002:   ESI = @p; 
;   003:   EDI = @q; 
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lea    ebx, [z]
    lea    esi, [p]
    lea    edi, [q]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Loop for every 32 bits * 8 
;
;   004:   ECX = 4 * 8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    lea    ecx, [4 * 8]


    xor    eax, eax
.loop:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   EAX = EAX + (ESI^ + EDI^);
;   006:   EAX = EAX / 10; 
;   007:   EBX^ += EDX;
;   008:   ++ EBX;
;   009:   ++ ESI;
;   010:   ++ EDI;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    add    al, byte [esi]
    add    al, byte [edi]

    xor    edx, edx
    div    dword [base]

    add    dl, byte [ebx]
    mov    byte [ebx], dl

    add    ebx, 1
    add    esi, 1
    add    edi, 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   -- ECX;
;   012:   if ECX != 0, goto .loop;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    ecx, 1
    jnz    .loop


.endloop:


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
