;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;             Face Recognition using Eigenface Algorithm
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 22-FEB-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

%include "constants.inc"
%include "data.inc"

extern loadpgm
global _start

section .text

_start:


    lea    eax, [filename_s01_01]
    mov    ebx, FACE_WIDTH
    mov    ecx, FACE_HEIGHT
    lea    edx, [s01_01_raw]
    call   loadpgm


exit_success:

    mov    eax, EXIT
    mov    ebx, 0
    int    0x80

exit_failure:

    mov    eax, EXIT
    mov    ebx, 1
    int    0x80
