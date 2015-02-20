;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; SSE2_ImageFilter_Mean.asm
;
; Mean Filter (15px * 15px)
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

    lea    esi, [imgCurrent.pixel] ;source pixels
    lea    edi, [imgFiltered.pixel] ;destination pixels

;Set the destination pixel starts at XY coordinate (7, 7).
;So that the destination pixels are drawed at the center of
;the mean filter box.

    add    edi, ( (_ROWSIZE_32_ * 7) + (7 * _COLUMNSIZE_32_) )


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
    cmp    ecx, (640 - _MEANBOX_WIDTH_)
    jb     loopColumn_meanFilter

endloopColumn_meanFilter:

    add    edi, (_MEANBOX_WIDTH_ * _COLUMNSIZE_32_)

    ;++ row
    add    ebp, (1 << 16)
    cmp    ebp, ((480 - _MEANBOX_WIDTH_ ) << 16)
    jb     loopRow_meanFilter

endloopRow_meanFilter:


;At this point, we have done mean filter.
;This loop_meanFilter_saveToXImage() will convert the
;imgFiltered to XImage format, also rewrite the imgCurrent.

    lea    esi, [imgFiltered.pixel]
    lea    edi, [XImage.pixel]
    lea    ebx, [imgCurrent.pixel]
    mov    ecx, (640*480)

loop_meanFilter_saveToXImage:

    movdqa   xmm1, [esi]
    movaps   xmm2, xmm1
    cvtps2dq xmm1, xmm1  ;Convert single-precision to dword
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


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Upload the processed image to the main window pixmap
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;Set putImage structure
    mov    eax, [mainWindow.pid]
    mov    ebx, [mainWindow.cid]
    xor    ecx, ecx
    mov    [putImage.drawable], eax
    mov    [putImage.gc], ebx
    mov    [putImage.dstY], cx

    lea    edi, [XImage.pixel]
    mov    esi, edi
    add    esi, (25600 * 47)

align 16, nop
loop_upload_meanFilter:

;POLL( {socketX, _POLLOUT_}, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax 
    mov    [poll.events], ebx 
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

;WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage]
    mov    edx, 24
    int    0x80

    xor    eax, eax
    mov    ax, [putImage.dstY]
    add    eax, 10
    mov    [putImage.dstY], ax

;WRITE( socketX, @EDI, 25600 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, 25600
    int    0x80

    add    edi, 25600
    cmp    edi, esi
    jbe    loop_upload_meanFilter

endloop_upload_meanFilter:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;
;   Tell X Server to draw the pixmap.
;   Make sure X Server is ready to receive request, because
;   the server needs some time to process the pixmap.
;   Waiting for some milliseconds before sending request is needed
;   to prevent overflow from X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

;POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax 
    mov    [poll.events], ebx 
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;
;   Draw/Redraw the testimage by using CopyArea request.
;   Using CopyArea request to draw image is much more efficient
;   compared to PutImage request. The PutImage request should only
;   be used to put data pixel onto pixmap, and then use CopyArea
;   request to copy the picture from pixmap to the main window.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

;WRITE( socketX, @copyArea 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea]
    mov    edx, 28
    int    0x80

;Done with SSE2_ImageFilter_Mean(). Exit the function.
    jmp    mainloop




;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;
;   Calculate the mean filter box with size (15px * 15px)
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
