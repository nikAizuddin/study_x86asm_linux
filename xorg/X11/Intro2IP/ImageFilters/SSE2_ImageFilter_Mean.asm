;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; SSE2_ImageFilter_Mean.asm
;
; Mean Filter (3px * 3px)
;
; This source file contains function SSE2_ImageFilter_Mean().
; The function only executed when key "W" is pressed.
;
; Function SSE2_ImageFilter_Mean( void ) : void
;
;=====================================================================

section .text


SSE2_ImageFilter_Mean:

;   ###############################################
;   High Word Order EBP = row
;   Low Word Order  EBP = column
;
;   **These row and column are intended for
;     loopRow_meanFilter and loopColumn_meanFilter.
;   ###############################################

    xor    ebp, ebp

    pxor   xmm0, xmm0
    pxor   xmm7, xmm7
    movdqa xmm6, [meanDivisor]

    lea    esi, [imgCurrent.pixel]  ;source pixels
    lea    edi, [imgFiltered.pixel] ;destination pixels

;Set the destination pixel starts at XY coordinate (7, 7).
;So that the destination pixels are drawed at the center of
;the mean filter box.

    add    edi, ( (_ROWSIZE_32_    * _MEANBOX_CENTER_) + \
                  (_COLUMNSIZE_32_ * _MEANBOX_CENTER_) )


;These loopRow_meanFilter() and loopColumn_meanFilter() functions
;will perform mean filter calculations.

align 16, nop
loopRow_meanFilter:

    ;Reset column = 0
    xor    eax, eax
    mov    bp, ax

align 16, nop
loopColumn_meanFilter:

;Move the mean filter box to the next column and/or row.
;The calculations for moving the box will look like this:
;boxPosition( row*_ROWSIZE_, column*_COLUMNSIZE_ )

    lea    esi, [imgCurrent.pixel]

    mov    eax, ebp
    shr    eax, 16
    mov    ebx, _ROWSIZE_32_
    mul    ebx                   ;EAX = row * _ROWSIZE_32_
    add    esi, eax

    mov    eax, ebp
    and    eax, 0xffff
    mov    ebx, _COLUMNSIZE_32_
    mul    ebx                   ;EAX = column * _COLUMNSIZE_32_
    add    esi, eax

    jmp    calculate_meanPixel
    endCalculate_meanPixel:

    ;++ column
    add    ebp, 1
    mov    ecx, ebp
    and    ecx, 0xffff
    cmp    ecx, (_IMG_WIDTH_ - _MEANBOX_WIDTH_)
    jb     loopColumn_meanFilter

endloopColumn_meanFilter:

    add    edi, (_MEANBOX_WIDTH_ * _COLUMNSIZE_32_)

    ;++ row
    add    ebp, (1 << 16)
    cmp    ebp, ((_IMG_HEIGHT_ - _MEANBOX_WIDTH_ ) << 16)
    jb     loopRow_meanFilter

endloopRow_meanFilter:


;At this point, we have done mean filter.
;This loop_meanFilter_saveToXImage() will convert the
;imgFiltered to XImage format, also rewrite the imgCurrent.

    lea    esi, [imgFiltered.pixel]
    lea    edi, [XImage.pixel]
    lea    ebx, [imgCurrent.pixel]
    mov    ecx, (_IMG_WIDTH_ * _IMG_HEIGHT_)

loop_meanFilter_saveToXImage:

    movdqa   xmm1, [esi]
    movaps   xmm2, xmm1
    cvtps2dq xmm1, xmm1  ;Convert single-precision to dword integer
    packssdw xmm1, xmm7  ;Convert dword to word
    packuswb xmm1, xmm7  ;Convert word to byte
    movd     [edi], xmm1
    movdqa   [ebx], xmm2

    add    esi, _COLUMNSIZE_32_
    add    ebx, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_8_
    sub    ecx, 1
    jnz    loop_meanFilter_saveToXImage

endloop_meanFilter_saveToXImage:

    jmp    apply_ImageFilter




;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;
;   Calculate the mean filter box with size (3px * 3px)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

align 16, nop
calculate_meanPixel:

;   #################################
;   XMM1 = [ B:SP, G:SP, R:SP, A:SP ]
;   *SP stand for single-precision.
;   #################################

    pxor   xmm1, xmm1


;NOTE: loopBoxRow_meanFilter() and loopBoxCol_meanFilter will
;find the total value of imgFiltered pixels in the box.


    ;Set BoxRow
    mov    edx, _MEANBOX_WIDTH_

align 16, nop
loopBoxRow_meanFilter:

    ;Set/Reset BoxColumn
    mov    ecx, _MEANBOX_WIDTH_

align 16, nop
loopBoxCol_meanFilter:

    ;Load imgCurrent pixel, add to XMM1
    movdqa    xmm0, [esi]
    addps     xmm1, xmm0
    add       esi, _COLUMNSIZE_32_

    ;-- boxColumn
    sub    ecx, 1
    jnz    loopBoxCol_meanFilter

endloopBoxCol_meanFilter:

    ;Move imgCurrent pointer to next box row.
    add    esi, (_ROWSIZE_32_-(_MEANBOX_WIDTH_*_COLUMNSIZE_32_))

    ;-- boxRow
    sub    edx, 1
    jnz    loopBoxRow_meanFilter

endloopBoxRow_meanFilter:

    divps  xmm1, xmm6    ;Total pixel value / size of mean box
    movdqa [edi], xmm1
    add    edi, _COLUMNSIZE_32_

    jmp    endCalculate_meanPixel
