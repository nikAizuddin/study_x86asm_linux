;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; Display_Help.asm
;
; This source file contains function Display_Help().
; The function only executed when "F1" key is pressed.
;
; Function XEventFunc_KeyPress( void ) : void
;
;=====================================================================

section .text


Display_Help:


;Check if ImageFilter is blocked.
;If ImageFilter is currently blocked, draw the temporary XImage
;and reset the is_ImageFilter_blocked to FALSE.
;Otherwiese, if is_ImageFilter_blocked is currently FALSE,
;reset the is_ImageFilter_blocked to TRUE and draw the help image.

    mov    eax, [is_ImageFilter_blocked]
    cmp    eax, _FALSE_
    je     display_HelpImage

dont_display_HelpImage:
    mov    eax, _FALSE_
    mov    [is_ImageFilter_blocked], eax
    lea    edi, [temporary_XImage.pixel]
    jmp    upload_HelpImage

display_HelpImage:
    mov    eax, _TRUE_
    mov    [is_ImageFilter_blocked], eax
    lea    esi, [XImage.pixel]
    lea    edi, [temporary_XImage.pixel]
    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)
    rep    movsd
    lea    edi, [imgHelp.pixel]


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Upload the help image to the main window pixmap
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

upload_HelpImage:

;Set putImage structure
    mov    eax, [mainWindow.pid]
    mov    ebx, [mainWindow.cid]
    xor    ecx, ecx
    mov    [putImage.drawable], eax
    mov    [putImage.gc], ebx
    mov    [putImage.dstY], cx

;Loop 47 times to fill 480 lines
    mov    esi, edi
    add    esi, (_IMG_UPLOAD_SIZE_ * ((_IMG_HEIGHT_/10) - 1))

align 16, nop
loop_upload_HelpImage:

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

endloop_upload_HelpImage:


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

    jmp    mainloop
