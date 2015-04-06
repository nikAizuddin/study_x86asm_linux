;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data.inc
;
; This header file contains data.
;
;=====================================================================

section .bss

    align 16, resb 1
    Q:    resd (4*1)
    R:    resd (4*4)

section .data

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Matrix A, sample matrix
    ;   Number of rows = 4
    ;   Number of columns = 4
    ;   Column size = 4 bytes
    ;   Row size = 4 bytes * number of columns = 16
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, db 0
    A:    ;row 0
          dd __float32__( 4.000) ;A[0,0]
          dd __float32__( 0.021) ;A[0,1]
          dd __float32__(-7.043) ;A[0,2]
          dd __float32__(21.898) ;A[0,3]

          ;row 1
          dd __float32__( 0.000) ;A[1,0]
          dd __float32__( 3.000) ;A[1,1]
          dd __float32__( 0.873) ;A[1,2]
          dd __float32__( 3.202) ;A[1,3]

          ;row 2
          dd __float32__( 0.000) ;A[2,0]
          dd __float32__( 0.000) ;A[2,1]
          dd __float32__( 2.000) ;A[2,2]
          dd __float32__(-3.642) ;A[2,3]

          ;row 3
          dd __float32__( 0.000) ;A[3,0]
          dd __float32__( 0.000) ;A[3,1]
          dd __float32__( 0.000) ;A[3,2]
          dd __float32__( 1.000) ;A[3,3]
