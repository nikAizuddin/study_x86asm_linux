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
    s08_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    align 16, resb 1
    s08_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    align 16, resb 1
    s08_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    align 16, resb 1
    s08_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    align 16, resb 1
    s08_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    XImage:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; 32-bit single-precision data pixels.
    ; We use single-precision to process image because SSE
    ; instruction can only divide single-precision value.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    align 16, resb 1
    s08_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s08_01_normalized:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_02_normalized:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_03_normalized:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_04_normalized:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_05_normalized:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s08_01_covariance:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_02_covariance:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_03_covariance:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_04_covariance:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_05_covariance:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    faceMean:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)


section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; ImageFilter functions are blocked if _TRUE_
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    align 16, db 0
    is_ImageFilter_blocked:  dd _FALSE_


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Data for mean faces
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    align 16, db 0
    meanDivisor:
        .b:                  dd __float32__(5.0)
        .g:                  dd __float32__(5.0)
        .r:                  dd __float32__(5.0)
        .a:                  dd __float32__(5.0)

    align 16, db 0
    maskRemoveSign:
        .b: dd 0b01111111111111111111111111111111
        .g: dd 0b01111111111111111111111111111111
        .r: dd 0b01111111111111111111111111111111
        .a: dd 0b01111111111111111111111111111111
