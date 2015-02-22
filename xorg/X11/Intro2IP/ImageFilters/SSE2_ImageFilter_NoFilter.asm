;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; SSE2_ImageFilter_NoFilter.asm
;
; Restore imgCurrent to original image.
;
; This source file contains function SSE2_ImageFilter_NoFilter().
; The function only executed when key "Q" is pressed.
;
; Function SSE2_ImageFilter_NoFilter( void ) : void
;
;=====================================================================

section .text


SSE2_ImageFilter_NoFilter:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This loop_NoFilter_restore() will fill the imgCurrent pixel
;   and XImage pixel with imgOriginal pixel.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [imgOriginal.pixel] ;source pixel
    lea    edi, [imgCurrent.pixel]  ;destination1 pixel
    lea    ebx, [XImage.pixel]      ;destination2 pixel

    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_NoFilter_restore:

    movdqa xmm0, [esi]
    movdqa xmm1, xmm0

    cvtps2dq xmm1, xmm1 ;Convert single-precision to dword
    packssdw xmm1, xmm7 ;Convert dword to word
    packuswb xmm1, xmm7 ;Convert word to byte

    movdqa  [edi], xmm0
    movd    [ebx], xmm1

    add    esi, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_32_
    add    ebx, _COLUMNSIZE_8_

    sub    ecx, 1
    jnz    loop_NoFilter_restore

endloop_NoFilter_restore:


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
loop_upload_NoFilter:

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
    jbe    loop_upload_NoFilter

endloop_upload_NoFilter:


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

;Done with SSE2_ImageFilter_NoFilter(). Exit the function.
    jmp    mainloop
