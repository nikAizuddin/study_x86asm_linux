;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;             Find the value of mean from a data set.
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 11-MAC-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: x86_64
;         KERNEL: Linux x86
;         FORMAT: elf32
;
;=====================================================================

%include "include/constants.inc"
global _start


section .data

    align 16, db 0
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Sample data set
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    dataset_size:    dd 10
    dataset:         dd __float32__(11.6) ;dataset[0]
                     dd __float32__(12.6) ;dataset[1]
                     dd __float32__(12.7) ;dataset[2]
                     dd __float32__(12.8) ;dataset[3]
                     dd __float32__(13.3) ;dataset[4]
                     dd __float32__(13.3) ;dataset[5]
                     dd __float32__(13.6) ;dataset[6]
                     dd __float32__(13.7) ;dataset[7]
                     dd __float32__(13.8) ;dataset[8]
                     dd __float32__(11.4) ;dataset[9]


section .bss

    align 16, resb 0
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This variable will store the mean value. Print this variable
    ; using debugger GNU GDB to see the result.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    dataset_mean:    resd 1


section .text

_start:


;First, we have to find the total sum of dataset.

    pxor   xmm0, xmm0
    lea    esi, [dataset]      ;point ESI to base address of dataset
    mov    ecx, [dataset_size]

loop_sum:

    movss  xmm1, [esi]
    addss  xmm0, xmm1

    add    esi, 4      ;point the dataset pointer to the next data.
    sub    ecx, 1
    jnz    loop_sum

endloop_sum:


;Now we have the total sum of dataset. Lets divide it with the value
;of dataset size.

    cvtsi2ss xmm1, [dataset_size] ;convert int to float
    divss    xmm0, xmm1           ;sum of dataset / dataset size
    movss    [dataset_mean], xmm0 ;save the result to dataset_mean


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   At this point, we have finished calculating the mean value.
;   So, lets view the result using debugger GNU GDB.
;   Use these GDB commands to view the result:
;       (gdb) break exit_success
;       (gdb) run
;       (gdb) x/fw dataset_mean
;
;   If you want to view all the values in the dataset,
;   use this command:
;       (gdb) x/10fw dataset
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Exit the program
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_success:

    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
