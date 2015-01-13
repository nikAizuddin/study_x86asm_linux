;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                       Simple boot program
;                      ---------------------
;   This program is bootable and will display a message at the
;   screen if boot is successful. Compile this program using
;   NASM by executing this command:
;
;   $ nasm boot.asm -o boot.img -fbin
;
;   After you have successfully compile and no errors/warnings,
;   you need to convert the boot.img into boot.iso by executing
;   this command:
;
;   $ sudo mkisofs -pad -b boot.img -R -o boot.iso \
;     -no-emul-boot 4 -boot-load-size 4 boot.img
;
;   The safest way to run this bootloader program, is by using
;   the virtual machine (Oracle Virtualbox).
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 25-SEP-2014
;
;       LANGUAGE: 16-Bit Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: ---
;         KERNEL: ---
;         FORMAT: BIN
;
;=====================================================================

    bits   16
    org    0x7c00
    jmp    start

msg: db "Welcome to the simple boot program!"
msg_end:

start:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Point SI to address msg
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    xor    ax, ax
    mov    ds, ax                    ;ds = 0, to load msg
    mov    si, msg


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize cursor position to 0 (the top left corner)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    xor    dx, dx                   ;Cursor position = 0


print_msg:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set cursor position
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    ah, 2
    int    0x10


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Print 1 character at current cursor position
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    ah, 9                    ;9 for write character & color
    lodsb                           ;load a byte of the msg into AL
    mov    bx, 0x0f                 ;font color (0x0f = white)
    mov    cx, 1                    ;strlen to write = 1 character
    int    0x10

;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Move the cursor position by 1 character
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    add    dx, 1


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Loop until all characters from the msg are written.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    cmp    si, msg_end              ;did all characters are writted..?
    jne    print_msg


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   After finished writting all the characters, halt the program
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    hlt


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set boot sector signature at byte 510
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    times  0x200 - 2 - ($ - $$) db 0
    dw     0xaa55
