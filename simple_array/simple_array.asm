;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                      Simple array operations
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 13-JAN-2015
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

struc string
    .value:  resd 1
    .length: resd 1
    .size:
endstruc

section .rodata

    num:

        .0:
            istruc string
                at string.value,  dd 0x00000a33    ;num[0] = "3\n"
                at string.length, dd 2
            iend

        .1:
            istruc string
                at string.value,  dd 0x00000a32    ;num[1] = "2\n"
                at string.length, dd 2
            iend

        .2:
            istruc string
                at string.value,  dd 0x00000a36    ;num[2] = "6\n"
                at string.length, dd 2
            iend

        .3:
            istruc string
                at string.value,  dd 0x00000a38    ;num[3] = "8\n"
                at string.length, dd 2
            iend

        .4:
            istruc string
                at string.value,  dd 0x000a3239    ;num[4] = "92\n"
                at string.length, dd 3
            iend

        .5:
            istruc string
                at string.value,  dd 0x000a3034    ;num[5] = "40\n"
                at string.length, dd 3
            iend

        .6:
            istruc string
                at string.value,  dd 0x000a3135    ;num[6] = "51\n"
                at string.length, dd 3
            iend

        .7:
            istruc string
                at string.value,  dd 0x0a333231    ;num[7] = "123\n"
                at string.length, dd 4
            iend

        .8:
            istruc string
                at string.value,  dd 0x0a303234    ;num[8] = "420\n"
                at string.length, dd 4
            iend

        .9:
            istruc string
                at string.value,  dd 0x0a343933    ;num[9] = "394\n"
                at string.length, dd 4
            iend

section .data

    i: dd 10

section .text

_start:


;
;
;   Initialize source index
;
;
    lea    esi, [num.0]


.loop_display_array:


;
;
;   Print the value num[i]
;
;
    mov    eax, 0x04
    mov    ebx, 0x01
    lea    ecx, [esi                ]
    mov    edx, [esi + string.length]
    int    0x80


;
;
;   Point source index to next num
;
;
    lea    esi, [esi + string.size]


;
;
;   --i
;
;
    mov    eax, [i]
    sub    eax, 1
    mov    [i], eax


;
;
;   If i != 0,
;       goto .loop_display_array
;
;
    cmp    eax, 0
    jne    .loop_display_array



.exit:
    mov    eax, 0x01                ;systemcall exit
    xor    ebx, ebx                 ;return 0
    int    0x80
