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
    winTrainingImages:
        .width:              resw 1
        .height:             resw 1
        .wid:                resd 1 ;window id
        .cid:                resd 1 ;graphic context id

        .s01_01_pid:         resd 1 ;s01_01 face pixmap id
        .s01_02_pid:         resd 1
        .s01_03_pid:         resd 1
        .s01_04_pid:         resd 1
        .s01_05_pid:         resd 1

        .s02_01_pid:         resd 1
        .s02_02_pid:         resd 1
        .s02_03_pid:         resd 1
        .s02_04_pid:         resd 1
        .s02_05_pid:         resd 1

        .s03_01_pid:         resd 1
        .s03_02_pid:         resd 1
        .s03_03_pid:         resd 1
        .s03_04_pid:         resd 1
        .s03_05_pid:         resd 1

        .s04_01_pid:         resd 1
        .s04_02_pid:         resd 1
        .s04_03_pid:         resd 1
        .s04_04_pid:         resd 1
        .s04_05_pid:         resd 1

        .s05_01_pid:         resd 1
        .s05_02_pid:         resd 1
        .s05_03_pid:         resd 1
        .s05_04_pid:         resd 1
        .s05_05_pid:         resd 1


    winMeanSubtracted:
        .width:              resw 1
        .height:             resw 1
        .wid:                resd 1 ;window id
        .cid:                resd 1 ;graphic context id

        .s01_01_pid:         resd 1
        .s01_02_pid:         resd 1
        .s01_03_pid:         resd 1
        .s01_04_pid:         resd 1
        .s01_05_pid:         resd 1

        .s02_01_pid:         resd 1
        .s02_02_pid:         resd 1
        .s02_03_pid:         resd 1
        .s02_04_pid:         resd 1
        .s02_05_pid:         resd 1

        .s03_01_pid:         resd 1
        .s03_02_pid:         resd 1
        .s03_03_pid:         resd 1
        .s03_04_pid:         resd 1
        .s03_05_pid:         resd 1

        .s04_01_pid:         resd 1
        .s04_02_pid:         resd 1
        .s04_03_pid:         resd 1
        .s04_04_pid:         resd 1
        .s04_05_pid:         resd 1

        .s05_01_pid:         resd 1
        .s05_02_pid:         resd 1
        .s05_03_pid:         resd 1
        .s05_04_pid:         resd 1
        .s05_05_pid:         resd 1


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
    XImage_s01_01:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_02:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_03:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_04:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_05:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    XImage_s02_01:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_02:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_03:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_04:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_05:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    XImage_s03_01:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_02:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_03:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_04:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_05:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    XImage_s04_01:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_02:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_03:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_04:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_05:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    align 16, resb 1
    XImage_s05_01:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_02:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_03:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_04:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_05:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)


    align 16, resb 1
    XImage_s01_01_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_02_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_03_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_04_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s01_05_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    XImage_s02_01_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_02_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_03_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_04_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s02_05_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    XImage_s03_01_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_02_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_03_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_04_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s03_05_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    XImage_s04_01_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_02_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_03_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_04_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s04_05_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)

    XImage_s05_01_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_02_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_03_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_04_meanSubtracted:
        .pixel:    resb (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    XImage_s05_05_meanSubtracted:
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
    transpose_faceMatrix:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_*15)

    align 16, resb 1
    covariance_faceMatrix: ;Also known as eigenface matrix
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_*15)

    align 16, resb 1
    meanFaces:
        .pixel:    resd (_IMG_WIDTH_*_IMG_HEIGHT_*_CHANNELS_BGRA_)
    meanFaces_normalized:
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
        .b:                  dd __float32__(25.0)
        .g:                  dd __float32__(25.0)
        .r:                  dd __float32__(25.0)
        .a:                  dd __float32__(25.0)

    align 16, db 0
    maxPixelIntensity:
        .b:                  dd __float32__(255.0)
        .g:                  dd __float32__(255.0)
        .r:                  dd __float32__(255.0)
        .a:                  dd __float32__(255.0)

    align 16, db 0
    maskRemoveSign:
        .b: dd 0b01111111111111111111111111111111
        .g: dd 0b01111111111111111111111111111111
        .r: dd 0b01111111111111111111111111111111
        .a: dd 0b01111111111111111111111111111111
