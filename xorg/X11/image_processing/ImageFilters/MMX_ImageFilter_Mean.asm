;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; MMX_ImageFilter_Mean.asm
;
; !!ATTENTION!!
; This source file is no longer used by the program. But I keep this
; file as a study reference.
;
; This source file contains function MMX_ImageFilter_Mean().
; The function only executed when key "W" is pressed.
;
; Function MMX_ImageFilter_Mean( void ) : void
;
;=====================================================================

section .text


MMX_ImageFilter_Mean:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize all imgFiltered pixels to 0.
;   Although this may be optional, and not necessary to be 0.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;   The counter will hold the value of image size
;   divided by 8 bytes. We divide by 8 bytes because we are writing
;   8 bytes chunk of data.

    mov    ecx, ((640*480*4) / 8)
    lea    esi, [imgFiltered.pixel]
    pxor   mm0, mm0

align 16, nop
loop_meanFilter_init:
    movq   [esi], mm0
    add    esi, 8
    sub    ecx, 1
    jnz    loop_meanFilter_init
endloop_meanFilter_init:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Apply mean filter (15x15)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;   ############################
;   High Word Order EBP = row
;   Low Word Order  EBP = column
;   ############################

    xor    ebp, ebp

    lea    esi, [imgOriginal.pixel] ;source pixels
    lea    edi, [imgFiltered.pixel] ;destination pixels

;   Set the destination pixel starts at XY coordinate (7, 7).
;   So that the destination pixels are drawed at the center of
;   the mean filter box.

    add    edi, ( (_LINESIZE_ * 7) + (7 * _NUM_OF_CHANNELS_) )


;   These loopRow_meanFilter() and loopColumn_meanFilter() functions
;   will perform mean filter calculations.

align 16, nop
loopRow_meanFilter:

    ;Reset column = 0
    xor    eax, eax
    mov    bp, ax

align 16, nop
loopColumn_meanFilter:

;   Move the mean filter box to the next column and/or row.
;   The calculations for moving the box will look like this:
;   boxPosition( row*_LINESIZE_, column*_NUM_OF_CHANNELS_ )

    lea    esi, [imgOriginal.pixel]

    mov    eax, ebp
    shr    eax, 16
    mov    ebx, _LINESIZE_
    mul    ebx                ;EAX = row * _LINESIZE_
    add    esi, eax

    mov    eax, ebp
    and    eax, 0xffff
    mov    ebx, _NUM_OF_CHANNELS_
    mul    ebx                ;EAX = column * _NUM_OF_CHANNELS_
    add    esi, eax

    jmp    calculate_meanPixel
    endCalculate_meanPixel:

    ;++ column
    add    ebp, 1
    mov    ecx, ebp
    and    ecx, 0xffff
    cmp    ecx, (640-15)
    jb     loopColumn_meanFilter

endloopColumn_meanFilter:

    add    edi, (15 * _NUM_OF_CHANNELS_)

    ;++ row
    add    ebp, (1 << 16)
    cmp    ebp, ((480-15) << 16)
    jb     loopRow_meanFilter

endloopRow_meanFilter:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Upload to the main window pixmap
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; Initialize putImage structure
    mov    eax, [mainWindow.pid]
    mov    ebx, [mainWindow.cid]
    xor    ecx, ecx
    mov    [putImage.drawable], eax
    mov    [putImage.gc], ebx
    mov    [putImage.dstY], cx

    lea    edi, [imgFiltered.pixel]
    mov    esi, edi
    add    esi, (25600 * 47)

align 16, nop
loop_upload_meanFilter:

; POLL( {socketX, _POLLOUT_}, 1, _POLL_INFINITE_TIMEOUT_ )
    mov    eax, [socketX]
    mov    ebx, _POLLOUT_
    mov    [poll.fd], eax 
    mov    [poll.events], ebx 
    mov    eax, _SYSCALL_POLL_
    lea    ebx, [poll]
    mov    ecx, 1
    mov    edx, _POLL_INFINITE_TIMEOUT_
    int    0x80

; WRITE( socketX, @putImage, 24 )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [putImage]
    mov    edx, 24
    int    0x80

    xor    eax, eax
    mov    ax, [putImage.dstY]
    add    eax, 10
    mov    [putImage.dstY], ax

; WRITE( socketX, @EDI, 25600 )
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
;   Make sure X Server is ready to receive request, because this
;   program perform mainloop faster than X Server.
;   Waiting for some milliseconds before sending request is needed
;   to prevent overflow from X Server.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

; POLL( @poll, 1, _POLL_INFINITE_TIMEOUT_ )
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

; WRITE( socketX, @copyArea 28 ) 
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, [socketX]
    lea    ecx, [copyArea]
    mov    edx, 28
    int    0x80

    jmp    mainloop




;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;
;   This will calculate the mean filter box (15 * 15)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

align 16, nop
calculate_meanPixel:

;   ############################################
;   MM1 = [ B:16bit, G:16bit, R:16bit, A:16bit ]
;   ############################################

    pxor   mm1, mm1

    ;Set BoxRow
    mov    edx, 15

align 16, nop
loopBoxRow_meanFilter:

    ;Reset BoxColumn
    mov    ecx, 15

align 16, nop
loopBoxCol_meanFilter:

    movd      mm0, [esi]
    punpcklbw mm0, mm7
    paddw     mm1, mm0
    add       esi, 4

    ;-- boxColumn
    sub    ecx, 1
    jnz    loopBoxCol_meanFilter

endloopBoxCol_meanFilter:

    add    esi, ((640*4) - (15*4))

    ;-- boxRow
    sub    edx, 1
    jnz    loopBoxRow_meanFilter


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
;
;   Calculates mean value
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    mov    ebx, (15*15)

    movd   eax, mm1
    and    eax, 0x0000ffff
    xor    edx, edx
    div    bx
    movd   mm0, eax ;blue channel

    movd   eax, mm1
    shr    eax, 16
    xor    edx, edx
    div    bx
    movd   mm6, eax ;green channel
    psllq  mm6, 8
    paddq  mm0, mm6

    psrlq  mm1, 32
    movd   eax, mm1
    xor    edx, edx
    div    bx
    movd   mm6, eax ;red channel
    psllq  mm6, 16
    paddq  mm0, mm6

    movd   [edi], mm0
    add    edi, 4

    jmp    endCalculate_meanPixel
