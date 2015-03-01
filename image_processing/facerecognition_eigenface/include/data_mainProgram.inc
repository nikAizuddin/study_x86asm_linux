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
    s01_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s01_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s01_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s01_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s01_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    s02_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s02_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s02_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s02_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s02_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    s03_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s03_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s03_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s03_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s03_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    s04_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s04_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s04_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s04_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s04_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    s05_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s05_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s05_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s05_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s05_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    s06_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s06_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s06_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s06_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s06_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    s07_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s07_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s07_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s07_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s07_05_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)

    align 16, resb 1
    s08_01_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s08_02_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s08_03_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
    s08_04_raw:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_GRAY_)
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

    ;---- Original single precision pixels ---------------------------

    align 16, resb 1
    s01_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s02_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s03_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s04_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s05_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s06_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s07_01_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_02_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_03_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_04_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_05_float:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

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


    ;---- Mean subtracted single precision pixels --------------------

    align 16, resb 1
    s01_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s01_05_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s02_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s02_05_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s03_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s03_05_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s04_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s04_05_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s05_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s05_05_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s06_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s06_05_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s07_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s07_05_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    s08_01_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_02_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_03_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_04_meanSubtracted:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    s08_05_meanSubtracted:
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
    meanFaces:
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
