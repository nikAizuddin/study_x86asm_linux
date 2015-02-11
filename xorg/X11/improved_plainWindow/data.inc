;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data.inc
;
; This header file containts structures.
;
;=====================================================================

section .bss

    socketX:                 resd 1

    args:
        .param1:             resd 1
        .param2:             resd 1
        .param3:             resd 1
        .param4:             resd 1

    poll: 
        .fd:                 resd 1
        .events:             resw 1
        .revents:            resw 1

    authenticateStatus:      resw 1 ;used to check auth status

    authenticateSuccess:
        .majorVersion:       resw 1 ;protocol major version
        .minorVersion:       resw 1 ;protocol minor version
        .lenAddData:         resw 1 ;len of additional data in dword

    additionalData:          resb 4096

    requestStatus:
        .success:            resb 1
        .code:               resb 1
        .sequenceNumber:     resw 1
        .ridBad:             resd 1 ;if success == 0
        .minorOpcode:        resw 1
        .majorOpcode:        resb 1
        .unused_02:          resb 21

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
        .whitePx:            resd 1    ;0x00ffffff
        .blackPx:            resd 1    ;0x00000000
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

    contactX:
        .family:             dw _AF_LOCAL_
        .fileLocation:       db "/tmp/.X11-unix/X0",0
    contactX_len:            dd ($ - contactX)

    authenticateX:
        .byteOrder:          db 0x6c
        .unused_01:          db 0
        .majorVersion:       dw 11
        .minorVersion:       dw 0
        .nbytesAuthProto:    dw 0
        .nbytesAuthStr:      dw 0
        .unused_02:          db 0
        .unused_03:          db 0
    authenticateX_len:       dd ($ - authenticateX)

    mainWindow:
        .opcode:             db _REQUEST_CREATEWINDOW_
        .depth:              db _CopyFromParent_
        .requestLength:      dw 8 ;(8+24)
        .wid:                dd 0
        .parent:             dd 0
        .x:                  dw 100
        .y:                  dw 100
        .width:              dw 640
        .height:             dw 480
        .borderWidth:        dw 4
        .class:              dw _InputOutput_
        .visual:             dd _CopyFromParent_
        .valueMask:          dd 0

    mapWindow:
        .opcode:             db _REQUEST_MAPWINDOW_
        .unused:             db 0
        .requestLength:      dw 2
        .wid:                dd 0
