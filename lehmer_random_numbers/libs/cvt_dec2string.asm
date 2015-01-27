;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;            FUNCTION: cvt_dec2string
;    FUNCTION PURPOSE: <See doc/description file>
;
;              AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;               EMAIL: nickaizuddin93@gmail.com
;        DATE CREATED: 14-OCT-2014
;
;        CONTRIBUTORS: ---
;
;            LANGUAGE: x86 Assembly Language
;              SYNTAX: Intel
;           ASSEMBLER: NASM
;        ARCHITECTURE: i386
;              KERNEL: Linux 32-bit
;              FORMAT: elf32
;
;      EXTERNAL FILES: ---
;
;             VERSION: 0.1.30
;              STATUS: Alpha
;                BUGS: --- <See doc/bugs/index file>
;
;    REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See /LICENSE file.
;
;=====================================================================

global cvt_dec2string

section .text

cvt_dec2string:

;parameter 1 = addr_decimal_x:32bit
;parameter 2 = num_of_blocks:32bit
;parameter 3 = addr_out_string:32bit
;parameter 4 = addr_out_strlen:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes to store ebp
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack ptr to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to ebp, to get arguments
    mov    eax, [ebp     ]          ;get addr_decimal_x
    mov    ebx, [ebp +  4]          ;get num_of_blocks
    mov    ecx, [ebp +  8]          ;get addr_out_string
    mov    edx, [ebp + 12]          ;get addr_out_strlen

.setup_localvariables:
    sub    esp, 52                  ;reserve 52 bytes
    mov    [esp     ], eax          ;decimal_x_ptr
    mov    [esp +  4], ebx          ;num_of_blocks
    mov    [esp +  8], ecx          ;addr_out_string
    mov    [esp + 12], edx          ;addr_out_strlen
    mov    dword [esp + 16], 0      ;out_strlen 
    mov    dword [esp + 20], 0      ;decimal_y[0]
    mov    dword [esp + 24], 0      ;decimal_y[1]
    mov    dword [esp + 28], 0      ;decimal_y[0]_len
    mov    dword [esp + 32], 0      ;decimal_y[1]_len
    mov    dword [esp + 36], 0      ;temp
    mov    dword [esp + 40], 0      ;i
    mov    dword [esp + 44], 0      ;ascii_char
    mov    dword [esp + 48], 0      ;byte_pos


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check the number of decimal_x memory blocks.
;
;   If there are 2 memory blocks, that means decimal_x has
;   an integer value that more than 8 digits, such as 9 or 10
;   digits.
;
;   001:   if num_of_blocks == 2, goto .skip_decimal_x_1_block;
;          .goto_decimal_x_1_block:
;   002:       goto .decimal_x_1_block;
;          .skip_decimal_x_1_block:
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 4]           ;eax = num_of_blocks
    cmp    eax, 2
    je     .skip_decimal_x_1_block
.goto_decimal_x_1_block:
    jmp    .decimal_x_1_block
.skip_decimal_x_1_block:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If the decimal_x has 2 memory blocks.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.decimal_x_2_blocks:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   003:   decimal_y[0] = addr_decimal_x^
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = addr_decimal_x
    mov    eax, [eax]               ;eax = addr_decimal_x^
    mov    [esp + 20], eax          ;decimal_y[0] = addr_decimal_x^


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   004:   decimal_y[1] = (addr_decimal_x+4)^
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp]               ;eax = addr_decimal_x
    add    eax, 4
    mov    eax, [eax]               ;eax = (addr_decimal_x+4)^
    mov    [esp + 24], eax          ;decimal_y[1] = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   005:   decimal_y[0]_len = 8
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, 8
    mov    [esp + 28], eax          ;decimal_y[0]_len = 8


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_1: Find the number of nibbles in decimal_y[1].
;            The decimal_y[1]_len itself stores the number of
;            nibbles from decimal_y[1].
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_1
;
;   006:   temp = decimal_y[1]
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 24]          ;eax = decimal_y[1]
    mov    [esp + 36], eax          ;temp = eax


.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   007:   temp >>= 4
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    shr    eax, 4
    mov    [esp + 36], eax          ;temp = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   ++ decimal_y[1]_len
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = decimal_y[1]_len
    add    eax, 1
    mov    [esp + 32], eax          ;decimal_y[1]_len = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   009:   if temp != 0, then
;              goto .loop_1
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    cmp    eax, 0
    jne    .loop_1


.endloop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_2: Convert decimal_y[1] to ASCII string,
;            and stores to output string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_2
;
;   010:   i = decimal_y[1]_len
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = decimal_y[1]_len
    mov    [esp + 40], eax          ;i = decimal_y[1]_len


.loop_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   011:   ascii_char = ((decimal_y[1] >> ( (i-1)*4 )) & 0x0f) | 0x30;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    ecx, eax
    mov    eax, [esp + 24]          ;eax = decimal_y[1]
    shr    eax, cl                  ;decimal_y[1] >>= ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = result


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   012:   addr_out_string^ |= ( ascii_char << (byte_pos*8) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    ecx, eax
    mov    eax, [esp + 44]          ;eax = ascii_char
    shl    eax, cl                  ;eax <<= (byte_pos*8)
    mov    ecx, [esp +  8]          ;ecx = addr_out_string
    mov    ebx, [ecx]               ;ebx = addr_out_string^
    or     eax, ebx                 ;addr_out_string^ |= result
    mov    [ecx], eax               ;save result to addr_out_string^


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   013:   ++ out_strlen
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   014:   ++ byte_pos
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pox + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   015:   -- i 
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i - 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   016:   if i != 0, then
;              goto .loop_2;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]         ;eax = i
    cmp    eax, 0
    jne    .loop_2


.endloop_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_3: Convert decimal_y[0] to ASCII string,
;            and append to output string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_3
;
;   017:   i = decimal_y[0]_len
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = decimal_y[0]_len
    mov    [esp + 40], eax          ;i = decimal_y[0]_len


.loop_3:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   018:   ascii_char = ((decimal_y[0] >> ( (i-1)*4) ) & 0x0f) | 0x30;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= 4
    mov    ecx, eax                 ;ecx = ((i-1)*4)
    mov    eax, [esp + 20]          ;eax = decimal_y[0]
    shr    eax, cl                  ;eax >>= ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = result


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   019:   addr_out_string^ |= ( ascii_char << (byte_pos*8) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;byte_pos *= 8
    mov    ecx, eax                 ;ecx = (byte_pos*8)
    mov    eax, [esp + 44]          ;eax = ascii_char
    shl    eax, cl                  ;eax <<= (byte_pos*8)
    mov    ecx, [esp +  8]          ;ecx = addr_out_string
    mov    ebx, [ecx]               ;ebx = addr_out_string^
    or     eax, ebx                 ;addr_out_string^ |= result
    mov    [ecx], eax               ;save result to addr_out_string^


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   020:   ++ out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen 
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   021:   ++ byte_pos
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pos + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if output string memory block is full.
;
;   TRUE  = The output string memory block is not yet full.
;   FALSE = The output string memory block is full.
;
;   If the output string memory block is full, point the
;   addr_out_string to the next memory block of output string,
;   and reset the byte position to 0.
;
;   022:   if byte_pos != 4, then
;              goto .cond1_out_string_not_full;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    cmp    eax, 4
    jne    .cond1_out_string_not_full      


.cond1_out_string_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   023:   addr_out_string += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = addr_out_string
    add    eax, 4
    mov    [esp + 8], eax           ;addr_out_string = (eax + 4)


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   024:   byte_pos = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [esp + 48], eax          ;byte_pos = eax


.cond1_out_string_not_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   025:   -- i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   026:   if i != 0, then
;             goto .loop_3;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    cmp    eax, 0
    jne    .loop_3


.endloop_3:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Skip .decimal_x_1_block.
;
;   027:   goto .save_out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    jmp    .save_out_strlen


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   If the decimal_x has only 1 memory block.
;   Means, the decimal_x's value is less than 8 digits.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.decimal_x_1_block:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   028:   decimal_y[0] = addr_out_string^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = addr_out_string
    mov    eax, [eax]               ;eax = addr_out_string^
    mov    [esp + 20], eax          ;decimal_x_b0 = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_4: Find the number of nibbles in decimal_y[0].
;            The decimal_y[0]_len itself stores the number
;            of nibbles from decimal_y[0].
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_4
;
;   029:   temp = decimal_y[0];
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = decimal_y[0]
    mov    [esp + 36], eax          ;temp = eax


.loop_4:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   030:   temp >>= 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    shr    eax, 4
    mov    [esp + 36], eax          ;temp = temp >> 4


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   031:   ++ decimal_y[0]_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = decimal_y[0]_len
    add    eax, 1
    mov    [esp + 28], eax          ;decimal_y[0]_len = eax + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   032:   if temp != 0, then
;              goto .loop_4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = temp
    cmp    eax, 0
    jne    .loop_4


.endloop_4:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP_5: Convert decimal_y[0] to ASCII string,
;            and stores to output string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize counter for .loop_5
;
;   033:   i = decimal_y[0]_len;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = decimal_y[0]_len
    mov    [esp + 40], eax          ;counter = eax


.loop_5:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   034:   ascii_char = ((decimal_y[0] >> ((i-1)*4)) & 0x0f) | 0x30;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax = (i-1) * 4
    mov    ecx, eax
    mov    eax, [esp + 20]          ;eax = decimal_y[0]
    shr    eax, cl                  ;eax = decimal_y[0] >> ((i-1)*4)
    and    eax, 0x0f
    or     eax, 0x30
    mov    [esp + 44], eax          ;ascii_char = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   035:   addr_out_string^ |= ( ascii_char << (byte_pos*8) );
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;eax = byte_pos * 8
    mov    ecx, eax
    mov    eax, [esp + 44]          ;eax = ascii_char
    shl    eax, cl                  ;eax = ascii_char << (byte_pos*8)
    mov    ecx, [esp +  8]          ;ecx = addr_out_string
    mov    ebx, [ecx]               ;ebx = addr_out_string^
    or     eax, ebx                 ;eax = result | addr_out_string
    mov    [ecx], eax               ;addr_out_string^ = result


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   036:   ++ out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen
    add    eax, 1
    mov    [esp + 16], eax          ;out_strlen = out_strlen + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   037:   ++ byte_pos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    add    eax, 1
    mov    [esp + 48], eax          ;byte_pos = byte_pos + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if output string memory block is full.
;
;   TRUE  = The output string memory block is not yet full.
;   FALSE = The output string memory block is full.
;
;   If the output string memory block is full, point the
;   addr_out_string to the next memory block of output string,
;   and reset the byte position to 0.
;
;   038:   if byte_pos != 4 then
;              goto .cond2_out_string_not_full;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = byte_pos
    cmp    eax, 4
    jne    .cond2_out_string_not_full


.cond2_out_string_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   039:   addr_out_string += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 8]           ;eax = addr_out_string
    add    eax, 4
    mov    [esp + 8], eax           ;addr_out_string += 4


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   040:   byte_pos = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax
    mov    [esp + 48], eax          ;byte_pos = 0


.cond2_out_string_not_full:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   041:   -- i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    sub    eax, 1
    mov    [esp + 40], eax          ;i = i + 1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   042:   if i != 0, then
;              goto .loop_5;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = i
    cmp    eax, 0
    jne    .loop_5


.endloop_5:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the length of out_string
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.save_out_strlen:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   043:   addr_out_strlen^ = out_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = out_strlen
    mov    ebx, [esp + 12]          ;ebx = addr_out_strlen
    mov    [ebx], eax               ;addr_out_strlen^ = out_strlen


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset to ebp
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to its initial value
    add    esp, 4                   ;restore 4 bytes

    ret
