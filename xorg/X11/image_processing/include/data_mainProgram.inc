;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_mainProgram.inc
;
; This header file contains main program structures.
;
;=====================================================================

section .bss


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Stores window delete message. When a window is deleted,
    ; the X Server will send ClientMessage to the X Client,
    ; which contains delete message. The delete message can be
    ; found in ClientMessage.data[0].
    ;
    ; The program will have to compare this WMDeleteMessage
    ; variable with the ClientMessage.data[0] value.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    WMDeleteMessage:         resd 1


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This is WM_PROTOCOLS property atom, that will be used with
    ; WMDeleteMessage to set the window WM_DELETE_MESSAGE.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    WMProtocols:             resd 1


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Structure for the main window
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mainWindow:
        .width:              resw 1
        .height:             resw 1
        .wid:                resd 1 ;window id
        .cid:                resd 1 ;graphic context id
        .pid:                resd 1 ;pixmap id


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Image file descriptor
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    image_fd:                resd 1


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Data pixels
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, resb 1
    imgRaw:
        .pixel:              resb (640*480*4)

    align 16, resb 1
    XImage:
        .pixel:              resb (640*480*4)

    align 16, resb 1
    imgOriginal:
        .pixel:              resd (640*480*4)

    align 16, resb 1
    imgCurrent:
        .pixel:              resd (640*480*4)

    align 16, resb 1
    imgFiltered:
        .pixel:              resd (640*480*4)


section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Data for SSE2_ImageFilter_Mean()
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    align 16, db 0
    meanDivisor:
        .b:                  dd 225.0 ;box size = 15 * 15
        .g:                  dd 225.0
        .r:                  dd 225.0
        .a:                  dd 225.0
