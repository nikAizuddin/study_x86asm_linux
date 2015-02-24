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
    image_fd:          resd 1


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; 8-bit data pixels.
    ; X Server uses 8 bit pixel to display image. So, the
    ; 32-bit single-precision must be converted to 8-bit value.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, resb 1
    imgRaw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)

    align 16, resb 1
    helpImgRaw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)

    align 16, resb 1
    jetColormapRaw:
        .pixel:    resb (256*1*4)

    align 16, resb 1
    XImage:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)

    align 16, resb 1
    temporary_XImage:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)

    align 16, resb 1
    imgHelp:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; 32-bit single-precision data pixels.
    ; We use single-precision to process image because SSE
    ; instruction can only divide single-precision value.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, resb 1
    jetColormap:
        .pixel:    resd (256*1*4)

    align 16, resb 1
    imgOriginal:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)

    align 16, resb 1
    imgCurrent:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)

    align 16, resb 1
    imgFiltered:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_IMG_NCHANNELS_)


section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; ImageFilter functions are blocked if _TRUE_
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    align 16, db 0
    is_ImageFilter_blocked:  dd _FALSE_


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Data for SSE2_ImageFilter_Mean()
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    align 16, db 0
    meanDivisor:
        .b:                  dd _MEANBOX_AREA_
        .g:                  dd _MEANBOX_AREA_
        .r:                  dd _MEANBOX_AREA_
        .a:                  dd _MEANBOX_AREA_

    align 16, db 0
    maskRemoveSign:
        .b: dd 0b01111111111111111111111111111111
        .g: dd 0b01111111111111111111111111111111
        .r: dd 0b01111111111111111111111111111111
        .a: dd 0b01111111111111111111111111111111


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, db 0
    blueChannelMask:
        .b: dd 0xffffffff 
        .g: dd 0x0
        .r: dd 0x0
        .a: dd 0x0

    align 16, db 0
    greenChannelMask:
        .b: dd 0x0 
        .g: dd 0xffffffff
        .r: dd 0x0
        .a: dd 0x0

    align 16, db 0
    redChannelMask:
        .b: dd 0x0
        .g: dd 0x0
        .r: dd 0xffffffff
        .a: dd 0x0

    align 16, db 0
    bgraChannelDivisor: dd __float32__(3.0)
