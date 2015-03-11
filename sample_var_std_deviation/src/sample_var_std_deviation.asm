;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;     Find variance and standard deviation of a sample data set
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
    dataset:         dd __float32__(4.2) ;dataset[0]
                     dd __float32__(6.7) ;dataset[1]
                     dd __float32__(7.3) ;dataset[2]
                     dd __float32__(7.5) ;dataset[3]
                     dd __float32__(8.0) ;dataset[4]
                     dd __float32__(8.5) ;dataset[5]
                     dd __float32__(8.7) ;dataset[6]
                     dd __float32__(8.8) ;dataset[7]
                     dd __float32__(9.2) ;dataset[8]
                     dd __float32__(9.3) ;dataset[9]


section .bss

    align 16, resb 0
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; These variables will store the result. Print this variable
    ; using debugger GNU GDB to see the result at the end of the
    ; program.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    dataset_mean:            resd 1
    dataset_variance:        resd 1
    dataset_stdDeviation:    resd 1


section .text

_start:


;First, we have to find the mean value from the dataset.
;To find mean, we have to find the summation of the dataset,
;and then divide by the size of the dataset.

    pxor   xmm0, xmm0
    lea    esi, [dataset]      ;point ESI to base address of dataset 
    mov    ecx, [dataset_size]

loop_sumMean:

    movss  xmm1, [esi]
    addss  xmm0, xmm1

    add    esi, 4      ;point the dataset pointer to the next data.
    sub    ecx, 1
    jnz    loop_sumMean

endloop_sumMean:

    cvtsi2ss xmm1, [dataset_size] ;convert int to float
    divss    xmm0, xmm1           ;sum of dataset / dataset size
    movss    [dataset_mean], xmm0 ;save the result to dataset_mean


;At this point, we now have the mean value of the dataset.
;Now, lets find variance.

    pxor   xmm0, xmm0
    movss  xmm1, [dataset_mean]
    lea    esi, [dataset]
    mov    ecx, [dataset_size]

loop_sumVariance:

    movss  xmm2, [esi]
    subss  xmm2, xmm1  ;XMM2 = dataset[i] - mean
    mulss  xmm2, xmm2  ;Calculate power of 2

    addss  xmm0, xmm2

    add    esi, 4  ;Point the dataset pointer to the next data.
    sub    ecx, 1
    jnz    loop_sumVariance

endloop_sumVariance:

    mov         eax, [dataset_size]
    sub         eax, 1
    cvtsi2ss    xmm1, eax  ;XMM1 = dataset_size - 1
    divss       xmm0, xmm1
    movss       [dataset_variance], xmm0


;At this point, we have the value of variance from the dataset.
;Now lets find standard deviation.

    sqrtss    xmm0, xmm0
    movss     [dataset_stdDeviation], xmm0


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   At this point, we have finished calculating mean, variance,
;   and standard deviation. Now lets view the result by using
;   GNU GDB debugger. Use these GDB commands:
;       (gdb) break exit_success
;       (gdb) run
;
;   To view all dataset values,
;       (gdb) x/10fw &dataset
;
;   To view the value of mean,
;       (gdb) x/fw &dataset_mean
;
;   To view the value of variance,
;       (gdb) x/fw &dataset_variance
;
;   To view the value of standard deviation,
;       (gdb) x/fw &dataset_stdDeviation
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
