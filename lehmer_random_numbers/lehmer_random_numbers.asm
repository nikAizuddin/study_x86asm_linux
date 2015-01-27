;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;        Generate 10^7 random numbers using Lehmer Algorithm
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 27-JAN-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

extern string_append
extern cvt_hex2dec
extern cvt_dec2string
extern cvt_int2string
extern find_int_digits
extern pow_int

global _start

section .bss

    r_str:       resd 3
    r_strlen:    resd 1
    r:           resd 1

    i:           resd 1

section .rodata

    n:             dd 10000000
    seed:          dd 31
    multiplier:    dd 2
    modulo:        dd 1000000000

section .text

_start:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:     r = seed;
;   002:     cvt_int2string( r, @r_str, @r_strlen, 0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [seed]
    mov    [r], eax

    sub    esp, 16
    mov    eax, [r]
    lea    ebx, [r_str]
    lea    ecx, [r_strlen]
    xor    edx, edx
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_int2string
    add    esp, 16


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:     EDI = @r_str + r_strlen;
;   004:     EDI^ = 0x0a;
;   005:     ++ r_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [r_strlen]
    lea    edi, [r_str + ebx]
    mov    byte [edi], 0x0a
    add    ebx, 1
    mov    [r_strlen], ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:     WRITE( stdout, @r_str, r_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x04                ;systemcall write
    mov    ebx, 0x01                ;fd = stdout
    lea    ecx, [r_str]
    mov    edx, [r_strlen]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:     i = n - 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [n]
    sub    eax, 1
    mov    [i], eax


.loop:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:         r = ( pow_int(multiplier, (i%2)+1) * r ) % modulo;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [i]
    mov    ebx, 2
    xor    edx, edx
    div    ebx
    mov    ebx, edx

    add    ebx, 1

    sub    esp, 8
    mov    eax, [multiplier]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   pow_int
    add    esp, 8

    mov    ebx, [r]
    mul    ebx

    mov    ebx, [modulo]
    xor    edx, edx
    div    ebx

    mov    [r], edx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:         r_str = 0;
;   010:         cvt_int2string( r, @r_str, @r_strlen, 0 );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    lea    edi, [r_str]
    mov    [edi    ], eax
    mov    [edi + 4], eax
    mov    [edi + 8], eax

    sub    esp, 16
    mov    eax, [r]
    lea    ebx, [r_str]
    lea    ecx, [r_strlen]
    xor    edx, edx
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   cvt_int2string
    add    esp, 16


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:         EDI = @r_str + r_strlen;
;   012:         EDI^ = 0x0a;
;   013:         ++ r_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [r_strlen]
    lea    edi, [r_str + ebx]
    mov    byte [edi], 0x0a
    add    ebx, 1
    mov    [r_strlen], ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:         WRITE( stdout, @r_str, r_strlen );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 0x04                ;systemcall write
    mov    ebx, 0x01                ;fd = stdout
    lea    ecx, [r_str]
    mov    edx, [r_strlen]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:         -- i;
;   016:         if i != 0, goto .loop;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [i]
    sub    eax, 1
    mov    [i], eax
    cmp    eax, 0
    jne    .loop


.endloop:


exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
