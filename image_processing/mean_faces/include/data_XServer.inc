;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_XServer.inc
;
; This header file contains important XServer structures.
;
;=====================================================================


; ---- Resource ID info ----------------------------------------------
; mainWindow.wid            = XServer.ridBase + 0
; graphicContext.cid        = XServer.ridBase + 1
; testimage_pixmap.pid      = XServer.ridBase + 2
; --------------------------------------------------------------------


section .bss


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This socketX will be used to communicate with the X Server.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    socketX:                 resd 1


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This variable is used for checking authentication status.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    authenticateStatus:      resw 1 


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; If the connection is successfully authenticated, the
    ; X Server will send additional data. The additional data
    ; is very important because we need information such as
    ; resource base id, root window id, and XScreen information.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    authenticateSuccess:
        .majorVersion:       resw 1 ;protocol major version
        .minorVersion:       resw 1 ;protocol minor version
        .lenAddData:         resw 1 ;len of additional data in dword
    additionalData:          resb 4096


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; These XServer and XScreen structure will be filled with
    ; the additionalData received.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    XServer:
        .release:            resd 1    ;11.40.4000
        .ridBase:            resd 1    ;resource id base
        .ridMask:            resd 1    ;resource id mask
        .motionBufferSize:   resd 1    ;256
        .nbytesVendor:       resw 1    ;14 ("Fedora Project")
        .maxRequestLen:      resw 1    ;65535
        .numRoots:           resb 1    ;1
        .numFormats:         resb 1    ;7 (format_01 -> 07)
        .imageByteOrder:     resb 1    ;0 (LSBFirst)
        .bitmapBitOrder:     resb 1    ;0 (LeastSignificant)
        .bitmapScanlineUnit: resb 1    ;32
        .bitmapScanlinePad:  resb 1    ;32
        .minKeyCode:         resb 1    ;8
        .maxKeyCode:         resb 1    ;255
        .unused_01:          resd 1
        .vendorStr:          resd 8    ;"Fedora Project"

    XScreen:
        .root:               resd 1    ;0x00000081
        .defaultColormap:    resd 1    ;0x00000020
        .whitePixel:         resd 1    ;0x00ffffff
        .blackPixel:         resd 1    ;0x00000000
        .eventInputMask:     resd 1    ;0x00fac03f
        .widthInPx:          resw 1    ;1366
        .heightInPx:         resw 1    ;768
        .widthInMM:          resw 1    ;361
        .heightInMM:         resw 1    ;203
        .minInstalledMaps:   resw 1    ;1
        .maxInstalledMaps:   resw 1    ;1
        .rootVisual:         resd 1    ;0x00000021
        .backingStores:      resb 1    ;0
        .saveUnders:         resb 1    ;0
        .rootDepth:          resb 1    ;24
        .numDepth:           resb 1    ;7


section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This structure is used by the socketX to contact the
    ; X Server.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    contactX:
        .family:             dw _AF_LOCAL_
        .fileLocation:       db "/tmp/.X11-unix/X0",0
    contactX_size:           dd ($ - contactX)


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; The program will send this structure to the X Server to
    ; authenticate the connection.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    authenticateX:
        .byteOrder:          db 0x6c
        .unused_01:          db 0
        .majorVersion:       dw 11
        .minorVersion:       dw 0
        .nbytesAuthProto:    dw 0
        .nbytesAuthStr:      dw 0
        .unused_02:          db 0
        .unused_03:          db 0
    authenticateX_size:      dd ($ - authenticateX)
