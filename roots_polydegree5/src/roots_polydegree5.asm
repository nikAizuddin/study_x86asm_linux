;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;             Find the roots for polynomial of degree 5
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 05-MAC-2015
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

extern pow
global _start

section .data

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Minimum range and maximum range of x-axis.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    rangeMin:    dd __float32__(-8.0)
    rangeMax:    dd __float32__( 8.0)

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; The resolution of the graph. The lower the value, more
    ; accurate the value of roots. But, performance will suffer.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    resolution:  dd __float32__(0.0001)

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Coefficents from the equation: 2x^5 - 5x^3 - 10x + 9
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    a:    dd __float32__(2.0)  ;ax^5
    b:    dd __float32__(0.0)  ;bx^4 -- ignore
    c:    dd __float32__(5.0)  ;cx^3
    d:    dd __float32__(0.0)  ;dx^2 -- ignore
    e:    dd __float32__(10.0) ;ex
    f:    dd __float32__(9.0)  ;f

section .bss

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; The value of x will be first initialized with rangeMin value,
    ; and then will be added with resolution value until the value
    ; of x exceed rangeMax.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    x:    resd 1

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; These variables are just to temporarily store calculation
    ; results.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    x5:   resd 1
    x4:   resd 1
    x3:   resd 1
    x2:   resd 1
    ax5:  resd 1
    bx4:  resd 1
    cx3:  resd 1
    dx2:  resd 1
    ex1:  resd 1

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; The number of real roots. Will be equal or less then 5.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    numRoots:    resd 1

section .text

_start:


;Initializes the loop_find_roots.
    mov    ebx, 1           ;Assumes the value of y is negative
    movss  xmm6, [rangeMin] ;RESERVED! XMM6 will be the counter
    movss  xmm7, [rangeMax] ;RESERVED! XMM7 will be the limiter
    movss  [x], xmm6        ;x is initialized with rangeMin


align 16, nop
loop_find_roots:


;First, we have to find the value of x^5, x^4, x^3, and x^2.
;After we have the value, we will multiply them with their
;coefficients.


;find x^5
    movss  xmm0, [x]
    mov    eax, 5
    call   pow
    movss  [x5], xmm0

;find x^4
    movss  xmm0, [x]
    mov    eax, 4
    call   pow
    movss  [x4], xmm0

;find x^3
    movss  xmm0, [x]
    mov    eax, 3
    call   pow
    movss  [x3], xmm0

;find x^2
    movss  xmm0, [x]
    mov    eax, 2
    call   pow
    movss  [x2], xmm0


;At this point, we have all the value x^5, x^4, x^3, and x^2.
;Now lets multiply them with their coefficients.


;find a*x5
    movss  xmm0, [a]
    movss  xmm1, [x5]
    mulss  xmm0, xmm1
    movss  [ax5], xmm0

;find b*x4
    movss  xmm0, [b]
    movss  xmm1, [x4]
    mulss  xmm0, xmm1
    movss  [bx4], xmm0

;find c*x3
    movss  xmm0, [c]
    movss  xmm1, [x3]
    mulss  xmm0, xmm1
    movss  [cx3], xmm0

;find d*x2
    movss  xmm0, [d]
    movss  xmm1, [x2]
    mulss  xmm0, xmm1
    movss  [dx2], xmm0

;find e*x
    movss  xmm0, [e]
    movss  xmm1, [x]
    mulss  xmm0, xmm1
    movss  [ex1], xmm0


;At this point, we have multiplied all those values with their
;coefficients. Now lets find the value of y from the equation.


;find y, where y = 2x^5 - 5x^3 - 10x + 9
    movss  xmm0, [ax5]
    movss  xmm1, [bx4]
    movss  xmm2, [cx3]
    movss  xmm3, [dx2]
    movss  xmm4, [ex1]
    movss  xmm5, [f]

    subss  xmm0, xmm2
    subss  xmm0, xmm4
    addss  xmm0, xmm5


;At this point, we have successfully calculate the value of y,
;and its value is currently stored in XMM0.
;
;The next step is to check whether the value of y has cross the
;x-axis line or not.
;
;If the value y has cross the x-axis line, the sign value of y
;also be changed. This also means that we have found a root.
;The value of x is a root when y changes from negative to positive
;or from positive to negative.
;
;To view the root value by using gdb, follow this command:
;  (gdb) break sign_changes
;  (gdb) display/fw &x
;  (gdb) run
;  (gdb) continue
;  (gdb) continue
;  (gdb) continue


    xor      eax, eax
    movmskps eax, xmm0
    cmp      eax, ebx
    je       no_sign_changes


sign_changes:

    mov    ebx, eax
    mov    eax, [numRoots]
    add    eax, 1
    mov    [numRoots], eax

no_sign_changes:


;At this point we have finish calculating the equation.
;Now lets try the equation with next x value.


    addss   xmm6, [resolution]
    movss   [x], xmm6
    ucomiss xmm6, xmm7
    jbe     loop_find_roots


endloop_find_roots:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Exit the program
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_success:

    mov    eax, SYSCALL_EXIT
    mov    ebx, 0
    int    0x80
