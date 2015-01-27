;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: find_int_digits
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 11-OCT-2014
;
;       CONTRIBUTORS: ---
;
;           LANGUAGE: x86 Assembly Language
;             SYNTAX: Intel
;          ASSEMBLER: NASM
;       ARCHITECTURE: i386
;             KERNEL: Linux 32-bit
;             FORMAT: elf32

;      INCLUDE FILES: ---
;
;            VERSION: 0.1.21
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global find_int_digits

section .text

find_int_digits:

;parameter 1 = integer_x:32bit
;parameter 2 = flag:32bit
;returns = the number of digits from integer_x (EAX)

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes of stack
    mov    [esp], ebp               ;save ebp to stack memory
    mov    ebp, esp                 ;save current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offsets ebp, to get arguments
    mov    eax, [ebp    ]           ;get integer_x
    mov    ebx, [ebp + 4]           ;get flag

.set_localvariables:
    sub    esp, 16                  ;reserve 16 bytes
    mov    [esp     ], eax          ;integer_x
    mov    [esp +  4], ebx          ;flag
    mov    dword [esp +  8], 0      ;num_of_digits


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Is integer_x positive or negative?
;
;   If flag = 1, that means the integer_x is signed int.
;   So, we have to check its sign value to determine whether
;   it is a positive or negative number.
;
;   If the integer_x is negative number, we have to find the
;   value from its two's complement form.
;
;   If the integer_x is positive number, no need to find the
;   value from its two's complement form.
;
;   Otherwise if the flag = 0, skip these instructions.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check whether integer_x is signed or unsigned int.
;
;   001:   if flag != 1, then
;              goto .integer_x_is_unsigned;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 4]           ;eax = flag
    cmp    eax, 1
    jne    .integer_x_is_unsigned


.integer_x_is_signed:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is signed, check its sign value
;
;   002:   if (integer_x & 0x80000000) == 0, then
;              goto .integer_x_is_positive;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = integer_x
    and    eax, 0x80000000
    cmp    eax, 0
    je     .integer_x_is_positive


.integer_x_is_negative:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Looks like integer_x is negative, so invert all bits.
;
;   003:   integer_x = !integer_x;
;   004:   integer_x += 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = integer_x
    not    eax
    mov    [esp], eax               ;integer_x = !integer_x
    mov    eax, [esp]               ;eax = integer_x
    add    eax, 1
    mov    [esp], eax               ;integer_x = integer_x + 1


.integer_x_is_positive:
.integer_x_is_unsigned:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find the number of digits of integer_x.
;
;   Note: the conditional jump cannot jump more than 128 bytes.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    mov    eax, [esp]             ;eax = integer_x


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   if integer_x < 10, then
;              goto .jumper_10;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 10
    jb     .jumper_10


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   006:   if integer_x < 100, then
;              goto .jumper_100;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 100
    jb     .jumper_100


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   if integer_x < 1000, then
;              goto .jumper_1000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 1000
    jb     .jumper_1000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   if integer_x < 10000, then
;              goto .jumper_10000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 10000
    jb     .jumper_10000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   if integer_x < 100000, then
;              goto .jumper_100000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 100000
    jb     .jumper_100000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010:   if integer_x < 1000000, then
;              goto .jumper_1000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 1000000
    jb     .jumper_1000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   if integer_x < 10000000, then
;              goto .jumper_10000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 10000000
    jb     .jumper_10000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   if integer_x < 100000000, then
;              goto .jumper_100000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 100000000
    jb     .jumper_100000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   if integer_x < 1000000000, then
;              goto .jumper_1000000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    cmp    eax, 1000000000
    jb     .jumper_1000000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   if integer_x >= 1000000000, then
;              goto .more_equal_1000000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .more_equal_1000000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Jumpers, because cond. jumps can only jump up to 128 bytes.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.jumper_10:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:   goto .less_than_10;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_10


.jumper_100:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   goto .less_than_100;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_100


.jumper_1000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017:   goto .less_than_1000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_1000


.jumper_10000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   goto .less_than_10000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_10000


.jumper_100000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   goto .less_than_100000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_100000


.jumper_1000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   goto .less_than_1000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_1000000


.jumper_10000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   goto .less_than_10000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_10000000


.jumper_100000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   022:   goto .less_than_100000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_100000000


.jumper_1000000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   goto .less_than_1000000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .less_than_1000000000


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Assigns num_of_digits to a value based from jumpers
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.less_than_10:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   num_of_digits = 1;
;   025:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 1       ;num_of_digits = 1
    jmp    .endcondition


.less_than_100:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   num_of_digits = 2;
;   027:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 2       ;num_of_digits = 2
    jmp    .endcondition


.less_than_1000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   num_of_digits = 3;
;   029:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 3       ;num_of_digits = 3
    jmp    .endcondition


.less_than_10000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   030:   num_of_digits = 4;
;   031:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 4       ;num_of_digits = 4
    jmp    .endcondition


.less_than_100000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   032:   num_of_digits = 5
;   033:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 5       ;num_of_digits = 5
    jmp    .endcondition


.less_than_1000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   034:   num_of_digits = 6;
;   035:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 6       ;num_of_digits = 6
    jmp    .endcondition


.less_than_10000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   036:   num_of_digits = 7;
;   037:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 7       ;num_of_digits = 7
    jmp    .endcondition


.less_than_100000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   038:   num_of_digits = 8;
;   039:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 8       ;num_of_digits = 8
    jmp    .endcondition


.less_than_1000000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   040:   num_of_digits = 9;
;   041:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 9       ;num_of_digits = 9
    jmp    .endcondition


.more_equal_1000000000:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   042:   num_of_digits = 10;
;   043:   goto .endcondition;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    dword [esp + 8], 10      ;num_of_digits = 10


.endcondition:


.return:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   044:   return EAX = num_of_digits;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = num_of_digits


.clean_stackframe:
    sub    ebp, 8                   ;-8 bytes offsets to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes of stack

    ret
