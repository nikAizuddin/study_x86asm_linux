;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: cvt_int2string
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 01-NOV-2014
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
;     EXTERNAL FILES: find_int_digits.asm,
;                     cvt_hex2dec.asm,
;                     cvt_dec2string.asm,
;                     string_append.asm
;
;            VERSION: 0.1.50
;             STATUS: Alpha
;               BUGS: --- <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

extern find_int_digits
extern cvt_hex2dec
extern cvt_dec2string
extern string_append
global cvt_int2string

section .text

cvt_int2string:

;parameter 1 = integer_x:32bit
;parameter 2 = addr_out_string^:32bit
;parameter 3 = addr_out_strlen^:32bit
;parameter 4 = flag:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp     ]          ;get integer_x
    mov    ebx, [ebp +  4]          ;get addr_out_string
    mov    ecx, [ebp +  8]          ;get addr_out_strlen
    mov    edx, [ebp + 12]          ;get flag

.set_local_variables:
    sub    esp, 56                  ;reserve 56 bytes
    mov    [esp     ], eax          ;integer_x
    mov    [esp +  4], ebx          ;addr_out_string
    mov    [esp +  8], ecx          ;addr_out_strlen
    mov    [esp + 12], edx          ;flag
    mov    dword [esp + 16], 0      ;integer_x_len
    mov    dword [esp + 20], 0      ;integer_x_quo
    mov    dword [esp + 24], 0      ;integer_x_rem
    mov    dword [esp + 28], 0      ;decimal_x[0]
    mov    dword [esp + 32], 0      ;decimal_x[1]
    mov    dword [esp + 36], 0      ;ascii_x[0]
    mov    dword [esp + 40], 0      ;ascii_x[1]
    mov    dword [esp + 44], 0      ;ascii_x[2]
    mov    dword [esp + 48], 0      ;ascii_x_len
    mov    dword [esp + 52], 0      ;is_negative


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   001:   addr_out_strlen^ = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 8]           ;ebx = addr_out_strlen
    xor    eax, eax
    mov    [ebx], eax               ;addr_out_strlen = 0


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find the number of digits in integer_x
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   002:   integer_x_len = find_int_digits( integer_x, flag );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 8                   ;reserve 8 bytes
    mov    eax, [esp + 8     ]      ;get integer_x
    mov    ebx, [esp + 8 + 12]      ;get flag
    mov    [esp    ], eax           ;arg1: integer_x
    mov    [esp + 4], ebx           ;arg2: flag
    call   find_int_digits
    add    esp, 8                   ;restore 8 bytes
    mov    [esp + 16], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Checks whether integer_x is signed or unsigned
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   if flag != 1, then
;              goto .flag_notequal_1.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = flag
    cmp    eax, 1
    jne    .flag_notequal_1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is signed.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.flag_equal_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004: if (integer_x & 0x80000000) != 0x80000000, then
;            goto .sign_false.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp    ]           ;eax = integer_x
    and    eax, 0x80000000
    cmp    eax, 0x80000000
    jne    .sign_false


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is negative
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.sign_true:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   The integer_x is negative, and need Two's complement.
;
;   005: integer_x = (!integer_x) + 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = integer_x
    not    eax
    add    eax, 1
    mov    [esp], eax               ;integer_x = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Memorize the program that the integer_x is negative.
;
;   006: is_negative = 1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 1
    mov    [esp + 52], eax          ;is_negative = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is positive
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.sign_false:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If integer_x is unsigned.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


.flag_notequal_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   if integer_x_len > 8, goto .skip_int_x_len_le_8;
;          .goto_int_x_len_le_8:
;   008:       goto .integer_x_len_lessequal_8;
;          .skip_int_x_len_le_8:
;
;   Means, the number of digits in integer_x_len is
;   less than or equal 8.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = integer_x_len
    cmp    eax, 8
    jg     .skip_int_x_len_le_8
.goto_int_x_len_le_8:
    jmp    .integer_x_len_lessequal_8
.skip_int_x_len_le_8:


.integer_x_len_morethan_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009: integer_x_quo = integer_x / 100000000;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = integer_x
    mov    ebx, 100000000
    xor    edx, edx
    div    ebx                      ;eax /= ebx
    mov    [esp + 20], eax          ;integer_x_quo = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   010: integer_x_rem = remainder from the division;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    [esp + 24], edx          ;integer_x_rem = edx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011: decimal_x[0] = cvt_hex2dec( integer_x_rem );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4 + 24]      ;get integer_x_rem
    mov    [esp         ], eax      ;arg1: integer_x_rem
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 28], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012: decimal_x[1] = cvt_hex2dec( integer_x_quo );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4 + 20]      ;get integer_x_quo
    mov    [esp         ], eax      ;arg1: integer_x_quo
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 32], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013: cvt_dec2string( @decimal_x[0],
;                        2,
;                        @ascii_x[0],
;                        @ascii_x_len );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, esp
    mov    ecx, esp
    mov    edx, esp
    add    eax, (16+28)             ;get @decimal_x[0]
    mov    ebx, 2                   ;get num_of_blocks=2
    add    ecx, (16+36)             ;get @ascii_x[0]
    add    edx, (16+48)             ;get @ascii_x_len
    mov    [esp     ], eax          ;arg1: @decimal_x[0]
    mov    [esp +  4], ebx          ;arg2: num_of_blocks=2
    mov    [esp +  8], ecx          ;arg3: @ascii_x[0]
    mov    [esp + 12], edx          ;arg4: @ascii_x_len
    call   cvt_dec2string
    add    esp, 16                  ;restore 16 bytes


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014: goto .skip_integer_x_len_equalmore_8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .skip_integer_x_len_equalmore_8


.integer_x_len_lessequal_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015: decimal_x[0] = cvt_hex2dec(integer_x);
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 4                   ;reserve 4 bytes
    mov    eax, [esp + 4    ]       ;get integer_x
    mov    [esp        ], eax       ;arg1: integer_x
    call   cvt_hex2dec
    add    esp, 4                   ;restore 4 bytes
    mov    [esp + 28], eax          ;save return value


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016: cvt_dec2string( @decimal_x[0],
;                        1,
;                        @ascii_x[0],
;                        @ascii_x_len );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, esp
    mov    ecx, esp
    mov    edx, esp
    add    eax, (16+28)             ;get @decimal_x[0]
    mov    ebx, 1                   ;get num_of_blocks=1
    add    ecx, (16+36)             ;get @ascii_x[0]
    add    edx, (16+48)             ;get @ascii_x_len
    mov    [esp     ], eax          ;arg1: @decimal_x[0]
    mov    [esp +  4], ebx          ;arg2: num_of_blocks=1
    mov    [esp +  8], ecx          ;arg3: @ascii_x[0]
    mov    [esp + 12], edx          ;arg4: @ascii_x_len
    call   cvt_dec2string
    add    esp, 16                  ;restore 16 bytes


.skip_integer_x_len_equalmore_8:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   017: if is_negative != 1, then
;            goto .is_negative_false
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 52]          ;eax = is_negative
    cmp    eax, 1
    jne    .is_negative_false


.is_negative_true:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018: addr_out_string^ = 0x2d;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 4]           ;eax = addr_ascii_str
    mov    ebx, 0x2d                ;ebx = 0x2d
    mov    [eax], ebx               ;eax^ = ebx


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019: ++ addr_out_strlen^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 8]           ;ebx = addr_out_strlen
    mov    eax, [ebx]               ;eax = ebx^
    add    eax, 1                   ;eax += 1
    mov    [ebx], eax               ;ebx^ = eax

.is_negative_false:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020: string_append( addr_out_string,
;                       addr_out_strlen,
;                       @ascii_x[0],   
;                       ascii_x_len );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub    esp, 16                  ;reserve 16 bytes
    mov    eax, [esp + (16 + 4)]    ;get addr_out_string
    mov    ebx, [esp + (16 + 8)]    ;get addr_out_strlen
    mov    ecx, esp
    add    ecx, (16 + 36)           ;get @ascii_x[0]
    mov    edx, [esp + (16 + 48)]   ;get ascii_x_len
    mov    [esp     ], eax          ;arg1: addr_out_string
    mov    [esp +  4], ebx          ;arg2: addr_out_strlen
    mov    [esp +  8], ecx          ;arg3: @ascii_x[0]
    mov    [esp + 12], edx          ;arg4: ascii_x_len
    call   string_append
    add    esp, 16                  ;restore 16 bytes


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to remove arguments
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret
