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
;
; mainWindow.s01_01_pid     = XServer.ridBase + 2
; mainWindow.s01_02_pid     = XServer.ridBase + 3
; mainWindow.s01_03_pid     = XServer.ridBase + 4
; mainWindow.s01_04_pid     = XServer.ridBase + 5
; mainWindow.s01_05_pid     = XServer.ridBase + 6
;
; mainWindow.s02_01_pid     = XServer.ridBase + 7
; mainWindow.s02_02_pid     = XServer.ridBase + 8
; mainWindow.s02_03_pid     = XServer.ridBase + 9
; mainWindow.s02_04_pid     = XServer.ridBase + 10
; mainWindow.s02_05_pid     = XServer.ridBase + 11
;
; mainWindow.s03_01_pid     = XServer.ridBase + 12
; mainWindow.s03_02_pid     = XServer.ridBase + 13
; mainWindow.s03_03_pid     = XServer.ridBase + 14
; mainWindow.s03_04_pid     = XServer.ridBase + 15
; mainWindow.s03_05_pid     = XServer.ridBase + 16
;
; mainWindow.s04_01_pid     = XServer.ridBase + 17
; mainWindow.s04_02_pid     = XServer.ridBase + 18
; mainWindow.s04_03_pid     = XServer.ridBase + 19
; mainWindow.s04_04_pid     = XServer.ridBase + 20
; mainWindow.s04_05_pid     = XServer.ridBase + 21
;
; mainWindow.s05_01_pid     = XServer.ridBase + 22
; mainWindow.s05_02_pid     = XServer.ridBase + 23
; mainWindow.s05_03_pid     = XServer.ridBase + 24
; mainWindow.s05_04_pid     = XServer.ridBase + 25
; mainWindow.s05_05_pid     = XServer.ridBase + 26
;
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
