;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: pow_int
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 08-NOV-2014
;
;       CONTRIBUTORS: ---
;
;           LANGUAGE: x86 Assembly Language
;             SYNTAX: Intel
;          ASSEMBLER: NASM
;       ARCHITECTURE: i386
;             KERNEL: Linux 32-bit
;             FORMAT: elf32
;
;      INCLUDE FILES: ---
;
;            VERSION: 0.1.11
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global pow_int

section .text

pow_int:

;parameter 1: x:32bit
;parameter 2: y:32bit
;returns = result (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp    ]           ;get x the base value
    mov    ebx, [ebp + 4]           ;get y the power value

.set_local_variables:
    sub    esp, 16                  ;reserve 16 bytes
    mov    [esp     ], eax          ;x
    mov    [esp +  4], ebx          ;y
    mov    [esp +  8], ebx          ;i = y
    mov    dword [esp + 12], 1      ;result = 1


.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   result = result * x;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = result
    mov    ebx, [esp     ]          ;ebx = x
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 12], eax          ;result = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   --i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = i
    sub    eax, 1
    mov    [esp + 8], eax           ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   if i != 0, then
;              goto .loop_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = i
    cmp    eax, 0
    jne    .loop_1


.endloop_1:


.return:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   return result;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = result


.clean_stackframe:
    sub    ebp, 8                   ;-8 offset due to arguments
    mov    esp, ebp                 ;restore stack ptr to initial val
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret
