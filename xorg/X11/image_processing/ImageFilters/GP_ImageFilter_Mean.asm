;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; GP_ImageFilter_Mean.asm
;
; !!ATTENTION!!
; This source file is no longer used by the program. But I keep this
; file as a study reference.
;
; This source file contains function ImageFilter_Mean().
; The function only executed when key "W" is pressed.
;
; Function GP_ImageFilter_Mean( void ) : void
;
;=====================================================================

section .text


GP_ImageFilter_Mean:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Initialize imgFiltered to 0
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    xor    eax, eax
    lea    esi, [imgFiltered.pixel]
    mov    ecx, ((640*480*4) / 4)

loop_meanFilter_init:

    mov    [esi], eax
    add    esi, 4

    sub    ecx, 1
    jnz    loop_meanFilter_init

endloop_meanFilter_init:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Apply mean filter (15x15)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    sub    esp, 28
    mov    dword [esp     ], 0 ;row
    mov    dword [esp +  4], 0 ;col
    mov    dword [esp +  8], 0 ;boxRow
    mov    dword [esp + 12], 0 ;boxCol
    mov    dword [esp + 16], 0 ;R
    mov    dword [esp + 20], 0 ;G
    mov    dword [esp + 24], 0 ;B

    lea    esi, [imgOriginal.pixel]
    lea    edi, [imgFiltered.pixel]

    add    edi, ( (640*4*7) + (7*4) ) ;7 = (15-1)/2

loopRow_meanFilter:

    ; col = 0
    xor    eax, eax
    mov    [esp + 4], eax

    loopCol_meanFilter:

            ; boxRow = 0
            xor    eax, eax
            mov    [esp +  8], eax

            lea    esi, [imgOriginal.pixel]

            mov    eax, [esp    ]
            mov    ebx, (640*4)
            mul    ebx
            add    esi, eax

            mov    eax, [esp + 4]
            mov    ebx, 4
            mul    ebx
            add    esi, eax

            xor    eax, eax
            xor    ebx, ebx
            xor    edx, edx

            loopBoxRow_meanFilter:

                    ; boxCol = 0
                    mov    dword [esp + 12], 0

                    loopBoxCol_meanFilter:

                            xor    ecx, ecx

                            mov    cl, [esi  ]
                            add    eax, ecx

                            mov    cl, [esi+1]
                            add    ebx, ecx

                            mov    cl, [esi+2]
                            add    edx, ecx

                            add    esi, 4

                            ; ++ boxCol
                            mov    ecx, [esp + 12]
                            add    ecx, 1
                            mov    [esp + 12], ecx
                            cmp    ecx, 15
                            jb     loopBoxCol_meanFilter

                    endloopBoxCol_meanFilter:

                    add    esi, ((640*4) - (15*4))

                    ; ++ boxRow
                    mov    ecx, [esp + 8]
                    add    ecx, 1
                    mov    [esp + 8], ecx
                    cmp    ecx, 15
                    jb     loopBoxRow_meanFilter

            endloopBoxRow_meanFilter:

            mov    [esp + 16], eax
            mov    [esp + 20], ebx
            mov    [esp + 24], edx

            mov    ebx, (15*15)

            xor    edx, edx
            div    ebx
            mov    [esp + 16], eax

            mov    eax, [esp + 20]
            xor    edx, edx
            div    ebx
            mov    [esp + 20], eax

            mov    eax, [esp + 24]
            xor    edx, edx
            div    ebx
            mov    [esp + 24], eax

            mov    eax, [esp + 16]
            mov    ebx, [esp + 20]
            mov    edx, [esp + 24]

            mov    [edi  ], al 
            mov    [edi+1], bl
            mov    [edi+2], dl
            add    edi, 4

            ; ++ col
            mov    ecx, [esp + 4]
            add    ecx, 1
            mov    [esp + 4], ecx
            cmp    ecx, (640-15);
            jb    loopCol_meanFilter

    endloopCol_meanFilter:
    add    edi, (15*4)

    ; ++ row
    mov    ecx, [esp]
    add    ecx, 1
    mov    [esp], ecx
    cmp    ecx, (480-15)
    jb    loopRow_meanFilter

endloopRow_meanFilter:

    add    esp, 28


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
