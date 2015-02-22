;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; SSE2_ImageFilter_EDGradient.asm
;
; Perform edge detector based on image gradient.
;
; This source file contains function SSE2_ImageFilter_EDGradient().
; The function only executed when key "E" is pressed.
;
; Function SSE2_ImageFilter_EDGradient( void ) : void
;
;=====================================================================

section .text


SSE2_ImageFilter_EDGradient:

    pxor     xmm0, xmm0
    pxor     xmm1, xmm1
    movdqa   xmm7, [maskRemoveSign]

    lea    esi, [imgCurrent.pixel  + _COLUMNSIZE_32_ + _ROWSIZE_32_]
    lea    edi, [imgFiltered.pixel + _COLUMNSIZE_32_ + _ROWSIZE_32_]
    mov    edx, (_IMG_HEIGHT_ - 1)

align 16, nop
loopRow_EDGradient:

    mov    ecx, (_IMG_WIDTH_ - 1)

align 16, nop
loopColumn_EDGradient:

;XMM0 = left pixel
;XMM1 = right pixel
;XMM2 = above pixel
;XMM3 = below pixel

    movdqa   xmm0, [esi - _COLUMNSIZE_32_] ;left pixel
    movdqa   xmm1, [esi + _COLUMNSIZE_32_] ;right pixel
    movdqa   xmm2, [esi - _ROWSIZE_32_]    ;above pixel
    movdqa   xmm3, [esi + _ROWSIZE_32_]    ;below pixel

    movaps   xmm4, xmm0
    movaps   xmm5, xmm2

    subps    xmm4, xmm1
    subps    xmm5, xmm3

    andps    xmm4, xmm7
    andps    xmm5, xmm7
    addps    xmm4, xmm5

    movdqa   [edi], xmm4

    add    esi, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_32_
    sub    ecx, 1
    jnz    loopColumn_EDGradient

endloopColumn_EDGradient:

    sub    edx, 1
    jnz    loopRow_EDGradient

endloopRow_EDGradient:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Convert 32-bit single-precision to 8-bit and update the
;   imgCurrent pixel with imgFiltered pixel
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    pxor   xmm7, xmm7
    lea    esi, [imgFiltered]
    lea    edi, [XImage.pixel]
    lea    ebx, [imgCurrent.pixel]
    mov    ecx, (_IMG_WIDTH_ * _IMG_HEIGHT_)

align 16, nop
loop_EDGradient_saveToXimage:

    movdqa    xmm1, [esi]
    movaps    xmm2, xmm1
    cvtps2dq  xmm1, xmm1 ;Convert single-precision to dword integer
    packssdw  xmm1, xmm7 ;Convert dword to word
    packuswb  xmm1, xmm7 ;Convert word to byte
    movd      [edi], xmm1
    movdqa    [ebx], xmm2

    add    esi, _COLUMNSIZE_32_
    add    ebx, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_8_
    sub    ecx, 1
    jnz    loop_EDGradient_saveToXimage

endloop_EDGradient_saveToXimage:


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

;Loop 47 times to fill 480 lines
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

align 16, nop
loop_upload_EDGradient:

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

;WRITE( socketX, @EDI, _IMG_UPLOAD_SIZE_ )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    mov    ecx, edi
    mov    edx, _IMG_UPLOAD_SIZE_
    int    0x80

    add    edi, _IMG_UPLOAD_SIZE_
    cmp    edi, esi
    jbe    loop_upload_EDGradient

endloop_upload_EDGradient:


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

;Done with SSE2_ImageFilter_EDGradient(). Exit the function.
    jmp    mainloop
