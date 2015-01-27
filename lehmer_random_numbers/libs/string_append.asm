;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;      FUNCTION NAME: string_append
;   FUNCTION PURPOSE: <See doc/description file>
;
;             AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;              EMAIL: nickaizuddin93@gmail.com
;       DATE CREATED: 07-NOV-2014
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
;            VERSION: 0.1.22
;             STATUS: Alpha
;               BUGS: <See doc/bugs/index file>
;
;   REVISION HISTORY: <See doc/revision_history/index file>
;
;                 MIT Licensed. See LICENSE file.                     
;
;=====================================================================

global string_append

section .text

string_append:

;parameter 1 = addr_dst_str:32bit
;parameter 2 = addr_dst_strlen:32bit
;parameter 3 = addr_src_str:32bit
;parameter 4 = src_strlen:32bit
;returns = ---

.setup_stackframe:
    sub    esp, 4                   ;reserve 4 bytes
    mov    [esp], ebp               ;store ebp to stack
    mov    ebp, esp                 ;store current stack pointer to ebp

.get_arguments:
    add    ebp, 8                   ;+8 offset to get arguments
    mov    eax, [ebp     ]          ;get arg1: addr_dst_str
    mov    ebx, [ebp +  4]          ;get arg2: addr_dst_strlen
    mov    ecx, [ebp +  8]          ;get arg3: addr_src_str
    mov    edx, [ebp + 12]          ;get arg4: src_strlen

.set_local_variables:
    sub    esp, 56                  ;reserve 56 bytes
    mov    [esp     ], eax          ;addr_dst_str
    mov    [esp +  4], ebx          ;addr_dst_strlen
    mov    [esp +  8], ecx          ;addr_src_str
    mov    [esp + 12], edx          ;src_strlen
    mov    dword [esp + 16], 0      ;dst_strlen
    mov    dword [esp + 20], 0      ;current_dst_block
    mov    dword [esp + 24], 0      ;block_byte_offset
    mov    dword [esp + 28], 0      ;dst_ptr
    mov    dword [esp + 32], 0      ;src_ptr
    mov    dword [esp + 36], 0      ;src_buffer
    mov    dword [esp + 40], 0      ;dst_buffer
    mov    dword [esp + 44], 0      ;dst_buffer_bitpos
    mov    dword [esp + 48], 0      ;i
    mov    dword [esp + 52], 0      ;ascii_char


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize source pointer and fetch data from source
;   string memory block 0.
;
;   We have to initialize the source pointer, so that later we
;   can retrieve data in the memory block of the source string.
;   Lets say the source string is "! I am good", the source
;   pointer will point to the first character which is '!'.
;   See the diagram below:
;
;      src_ptr points here
;         V
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | ! |   | I |   | a | m |   | g | o | o | d |0x0|
;       |---------------|---------------|---------------|
;       |  mem block 0  |  mem block 1  |  mem block 2  |
;       |---------------|---------------|---------------|
;
;          Diagram 1: Memory view of the source string
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Point src_ptr to address source string.
;
;   001:   src_ptr = addr_src_str;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp +  8]          ;eax = addr_src_str
    mov    [esp + 32], eax          ;src_ptr = addr_src_str


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fetch 32 bits of data from source string memory block 0
;
;   002:   src_buffer = src_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 32]          ;ebx = src_ptr
    mov    eax, [ebx]               ;eax = src_ptr^
    mov    [esp + 36], eax          ;src_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get the value of destination string length.
;
;   We need to know the current string length of the destination
;   string, because later we have to find the memory address of the
;   end string of the destination string.
;
;   003:   dst_strlen = addr_dst_strlen^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  4]          ;ebx = addr_dst_strlen
    mov    eax, [ebx]               ;eax = addr_dst_strlen^
    mov    [esp + 16], eax          ;dst_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find current destination string block and its offset.
;
;   Because we need to know at which memory block the end
;   string is. For example, given dst_str is "HELLO WORLD",
;   in memory it looks like this:
;
;                                block_byte_offset = 8
;                                         V
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | H | E | L | L | O |   | W | O | R | L | D |   |
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       |---------------|---------------|---------------|
;       |  mem block 0  |  mem block 1  |  mem block 2  |
;       |---------------|---------------|---------------|
;                                               ^
;                                       current_dst_block
;           Diagram 2: destination string in memory
;
;   From the diagram above, the current_dst_block will
;   be 2, and the dst_ptr will point to address
;   mem block 2.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find current destination string memory block number.
;
;   004:   current_dst_block = dst_strlen / 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = dst_strlen
    mov    ebx, 4                   ;ebx = 4, to divide the eax
    xor    edx, edx                 ;prevent errors when division.
    div    ebx                      ;eax = eax / ebx
    mov    [esp + 20], eax          ;current_dst_block = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find the byte offset of the current destination string
;   memory block.
;
;   005:   block_byte_offset = current_dst_block * 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 20]          ;eax = current_dst_block
    mov    ebx, 4
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 24], eax          ;block_byte_offset = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find address of current destination string memory block,
;   so that later we can fetch data from the destination
;   string memory and store into a buffer.
;
;   For example, given current_dst_block = 2,
;   first we have to find the memory offset of the memory block 2,
;   (however, we already calculate the offset from previous
;   instructions):
;
;       offset = current dst block * 4 bytes;
;
;   After we have the memory offset, get the memory address
;   of destination string block 0, and add with offset:
;
;       address dst block 2 = address dst block 0 + offset;
;
;   Then we have the address of the dst block 2.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find address of current destination string memory block.
;
;   006:   dst_ptr = addr_dst_str + block_byte_offset;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp     ]          ;eax = addr_dst_str
    mov    ebx, [esp + 24]          ;ebx = block_byte_offset
    add    eax, ebx
    mov    [esp + 28], eax          ;dst_ptr = eax

;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fetch data from destination string and store to buffer.
;
;   007:   dst_buffer = dst_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 28]          ;ebx = dst_ptr
    mov    eax, [ebx]               ;eax = dst_ptr^
    mov    [esp + 40], eax          ;dst_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Find bit position of last character from the destination string
;
;   In order to append the string, we have to know the bit
;   position of the (last character + 1) in memory block of
;   destination string. Lets say the current memory block in
;   the destination string is at memory block 2,
;
;                                            dst_buffer_bitpos = 24
;                                                     V
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | H | E | L | L | O |   | W | O | R | L | D |0x0|
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       | 0 | 8 |16 |24 | 0 | 8 |16 |24 | 0 | 8 |16 |24 |
;       +---+---+---+---+---+---+---+---+---+---+---+---+
;       |---------------|---------------|---------------|
;       |  mem block 0  |  mem block 1  |  mem block 2  |
;       |---------------|---------------|---------------|
;                                               ^
;                                       current_dst_block
;            Diagram 3: destination string in memory
;
;   From the above diagram, the value of dst_buffer_bitpos will
;   be 24. Because, the end character of the string, which is 'D',
;   is located at bit 16 in memory block 2. So, the new
;   string will be append at byte position 24. The calculations
;   will look like this:
;
;   dst_buffer_bitpos = (dst_strlen - block_byte_offset) * 8 bits
;   dst_buffer_bitpos = (11 - 8) * 8
;   dst_buffer_bitpos = 3 * 8
;   dst_buffer_bitpos = 24
;
;   This bit position will be the bit position of the dst buffer.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   008:   dst_buffer_bitpos = (dst_strlen-block_byte_offset)*8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = dst_strlen
    mov    ebx, [esp + 24]          ;ebx = block_byte_offset
    sub    eax, ebx
    mov    ebx, 8
    xor    edx, edx
    mul    ebx                      ;eax *= ebx
    mov    [esp + 44], eax          ;dst_buffer_bitpos = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initializes counter for .loop_1
;
;   Set the counter initial value to the value of source
;   string length. This counter will be decremented until zero.
;   This counter prevents overflow and underflow when appending
;   the source string to the destination string.
;
;   When counter equals zero means that we have completely
;   append all characters from source string.
;
;   009:   i = src_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 12]          ;eax = src_strlen
    mov    [esp + 48], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .LOOP 1: Append the source string to the destination string
;
;   .loop_1 will loop until i = 0. Means that it will loop
;   until all source string has been appended to the destination
;   string.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.loop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if dst_buffer is full
;
;   True  = The destination string buffer is not yet full.
;           Continue filling the buffer with the string until
;           the destination string buffer is full.
;
;   False = The destination string buffer is full. Save the buffer
;           to the destination string, and then point the
;           destination pointer to the next memory location.
;           Also, reset the buffer and bit position of the
;           destination buffer to zero.
;
;   010:   if dst_buffer_bitpos != 32, then
;              goto .endcond_1;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = dst_buffer_bitpos
    cmp    eax, 32
    jne    .endcond_1


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .COND_1: If the destination string buffer is full
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.cond_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the buffer to the destination string.
;
;   011:   dst_ptr^ = dst_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = dst_buffer
    mov    ebx, [esp + 28]          ;ebx = dst_ptr
    mov    [ebx], eax               ;dst_ptr^ = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Point the destination pointer to the next memory location.
;
;   012:   dst_ptr += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 28]          ;eax = dst_ptr
    add    eax, 4                   ;eax = eax + 4
    mov    [esp + 28], eax          ;dst_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Reset the destination string buffer to zero.
;
;   013:   dst_buffer = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax                 ;eax = 0
    mov    [esp + 40], eax          ;dst_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;    Reset the destination string buffer bit position to zero.
;
;    014:   dst_buffer_bitpos = 0;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    xor    eax, eax                 ;eax = 0
    mov    [esp + 44], eax          ;dst_buffer_bitpos = eax


.endcond_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check if src_buffer is empty
;
;   True  = The source string buffer is not empty. Continue
;           appending the source string into the destination
;           string until the source string buffer is dry/empty.
;
;   False = The source string buffer is empty. Fetch the data
;           from next memory location of the source string, and
;           fill the source string buffer with the new data.
;
;   015:   if src_buffer != 0, then
;              goto .endcond_2;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = src_buffer
    cmp    eax, 0
    jne    .endcond_2


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   .COND_2: If the source string buffer is empty
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.cond_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Point the source pointer to the next memory location.
;
;   016:   src_ptr += 4;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 32]          ;eax = src_ptr
    add    eax, 4                   ;eax = eax + 4
    mov    [esp + 32], eax          ;src_ptr = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fetch the data from the next memory location.
;
;   017:   src_buffer = src_ptr^;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 32]          ;ebx = src_ptr
    mov    eax, [ebx]               ;eax = src_ptr^
    mov    [esp + 36], eax          ;src_buffer = eax


.endcond_2:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append a source character to destination string
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get source string character.
;
;   018:   ascii_char = (src_buffer&0xff) << dst_buffer_bitpos;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ecx, [esp + 44]          ;ecx = dst_buffer_bitpos
    mov    eax, [esp + 36]          ;eax = src_buffer
    and    eax, 0xff
    shl    eax, cl
    mov    [esp + 52], eax          ;ascii_char = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Append the source string character to the destination
;   character.
;
;   019:   dst_buffer |= ascii_char;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 40]          ;eax = dst_buffer
    mov    ebx, [esp + 52]          ;ebx = ascii_char
    or     eax, ebx
    mov    [esp + 40], eax          ;dst_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Increment bit position of the destination string.
;
;   020:   dst_buffer_bitpos += 8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 44]          ;eax = dst_buffer_bitpos
    add    eax, 8
    mov    [esp + 44], eax          ;dst_buffer_bitpos := eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Increase the length of destination string length by 1 byte.
;
;   021:   ++ dst_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 16]          ;eax = dst_strlen
    add    eax, 1
    mov    [esp + 16], eax          ;dst_strlen = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Remove the source character that has been read.
;
;   022:   src_buffer >>= 8;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 36]          ;eax = src_buffer
    shr    eax, 8
    mov    [esp + 36], eax          ;src_buffer = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Decrement length of source string by 1 byte.
;
;   023:   -- i;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = i
    sub    eax, 1
    mov    [esp + 48], eax          ;i = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check loop_1 condition, loop if true
;
;   024:   if i != 0, then
;              goto .loop_1;           
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    eax, [esp + 48]          ;eax = i
    cmp    eax, 0
    jne    .loop_1


.endloop_1:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save destination string and strlen to the argument out.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the destination string buffer to the destination
;   string memory block.
;
;   025:   dst_ptr^ = dst_buffer;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp + 28]          ;ebx = dst_ptr
    mov    eax, [esp + 40]          ;eax = dst_buffer
    mov    [ebx], eax               ;dst_ptr^ = eax


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Save the destination string length.
;
;   026: addr_dst_strlen^ = dst_strlen;
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mov    ebx, [esp +  4]          ;ebx = addr_dst_strlen
    mov    eax, [esp + 16]          ;eax = dst_strlen
    mov    [ebx], eax               ;addr_dst_strlen^ = eax


.return:

.clean_stackframe:
    sub    ebp, 8                   ;-8 offset due to arguments
    mov    esp, ebp                 ;restore stack ptr to initial value
    mov    ebp, [esp]               ;restore ebp to initial value
    add    esp, 4                   ;restore 4 bytes

    ret
