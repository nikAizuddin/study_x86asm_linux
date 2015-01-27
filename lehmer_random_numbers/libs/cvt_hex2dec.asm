;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: cvt_hex2dec
;   FUNCTION PURPOSE: <See doc/descrption file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 13-OCT-2014
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
;     EXTERNAL FILES: ---
;
;            VERSION: 0.1.11
;             STATUS: Alpha
;               BUGS: <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See LICENSE file.
;
;=====================================================================

global cvt_hex2dec

section .text

cvt_hex2dec:

;parameter 1 = hexadecimal_num:32bit
;returns = decimal number (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offsets, to get arguments
    mov    eax, [ebp]               ;get hexadecimal_num

.setup_localvariables:
    sub    esp, 80                  ;reserve 80 bytes of stack
    mov    [esp     ], eax          ;hexadecimal_num
    mov    dword [esp +  4], 0      ;decimal_num
    mov    dword [esp +  8], 0      ;A
    mov    dword [esp + 12], 0      ;B
    mov    dword [esp + 16], 0      ;C
    mov    dword [esp + 20], 0      ;D
    mov    dword [esp + 24], 0      ;E
    mov    dword [esp + 28], 0      ;F
    mov    dword [esp + 32], 0      ;G
    mov    dword [esp + 36], 0      ;H
    mov    dword [esp + 40], 0      ;I
    mov    dword [esp + 44], 0      ;J
    mov    dword [esp + 48], 0      ;K
    mov    dword [esp + 52], 0      ;L
    mov    dword [esp + 56], 0      ;M
    mov    dword [esp + 60], 0      ;N
    mov    dword [esp + 64], 0      ;O
    mov    dword [esp + 68], 0      ;P
    mov    dword [esp + 72], 0      ;Q
    mov    dword [esp + 76], 0      ;R


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   A = (hexadecimal_num / 1000000000)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 1000000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    [esp +  8], eax          ;A = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   B = 16 * A
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = A
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 12], eax          ;B = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   C = (hexadecimal_num / 100000000) + B
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecmal_num
    mov    ebx, 100000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 12]          ;ebx = B
    add    eax, ebx
    mov    [esp + 16], eax          ;C = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   D = 16 * C
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = C
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 20], eax          ;D = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   E = (hexadecimal_num / 10000000) + D
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 10000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 20]          ;ebx = D
    add    eax, ebx
    mov    [esp + 24], eax          ;E = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   F = 16 * E
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = E
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 28], eax          ;F = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   G = (hexadecimal_num / 1000000) + F
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 1000000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 28]          ;ebx = F
    add    eax, ebx
    mov    [esp + 32], eax          ;G = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   H = 16 * G
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = G
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 36], eax          ;H = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   I = (hexadecimal_num / 100000) + H
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 100000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 36]          ;ebx = H
    add    eax, ebx
    mov    [esp + 40], eax          ;I = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   J = 16 * I
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = I
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 44], eax          ;J = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   K = (hexadecimal_num / 10000) + J
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 10000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 44]          ;ebx = J
    add    eax, ebx
    mov    [esp + 48], eax          ;K = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   L = 16 * K
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = K
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 52], eax          ;L = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   M = (hexadecimal_num / 1000) + L
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 1000
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 52]          ;ebx = L
    add    eax, ebx
    mov    [esp + 56], eax          ;M = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   N = 16 * M
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 56]          ;eax = M
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 60], eax          ;N = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:   O = (hexadecimal_num / 100) + N
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 100
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 60]          ;ebx = N
    add    eax, ebx
    mov    [esp + 64], eax          ;O = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   P = 16 * O
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 64]          ;eax = O
    mov    ebx, 16
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 68], eax          ;P = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   Q = (hexadecimal_num / 10) + P
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, 10
    xor    edx, edx
    div    ebx                      ;eax = eax / ebx
    mov    ebx, [esp + 68]          ;ebx = P
    add    eax, ebx
    mov    [esp + 72], eax          ;Q = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   R = 6 * Q
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 72]          ;eax = Q
    mov    ebx, 6
    xor    edx, edx
    mul    ebx                      ;eax = eax * ebx
    mov    [esp + 76], eax          ;R = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   decimal_num = hexadecimal_num + R
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = hexadecimal_num
    mov    ebx, [esp + 76]          ;ebx = R
    add    eax, ebx
    mov    [esp +  4], eax          ;decimal_num = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   exit( decimal_num )
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.return:
    mov    eax, [esp + 4]           ;eax = decimal_num


.clean_stackframe:
    sub    ebp, 8                   ;-8 offsets, to get initial esp
    mov    esp, ebp                 ;restore esp to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret
