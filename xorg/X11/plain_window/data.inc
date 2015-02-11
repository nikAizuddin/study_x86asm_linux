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

    XEventReply:
        .code:               resd 1
        ;.detail:            resb 1
        ;.sequenceNumber:    resw 1

    XEvent_KeyPress:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .timestamp:          resd 1
        .root:               resd 1
        .event:              resd 1
        .child:              resd 1
        .rootX:              resw 1
        .rootY:              resw 1
        .eventX:             resw 1
        .eventY:             resw 1
        .state:              resw 1
        .sameScreen:         resb 1
        .unused:             resb 1

    XEvent_KeyRelease:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .timestamp:          resd 1
        .root:               resd 1
        .event:              resd 1
        .child:              resd 1
        .rootX:              resw 1
        .rootY:              resw 1
        .eventX:             resw 1
        .eventY:             resw 1
        .state:              resw 1
        .sameScreen:         resb 1
        .unused:             resb 1

    XEvent_ButtonPress:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .timestamp:          resd 1
        .root:               resd 1
        .event:              resd 1
        .child:              resd 1
        .rootX:              resw 1
        .rootY:              resw 1
        .eventX:             resw 1
        .eventY:             resw 1
        .state:              resw 1
        .sameScreen:         resb 1
        .unused:             resb 1

    XEvent_ButtonRelease:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .timestamp:          resd 1
        .root:               resd 1
        .event:              resd 1
        .child:              resd 1
        .rootX:              resw 1
        .rootY:              resw 1
        .eventX:             resw 1
        .eventY:             resw 1
        .state:              resw 1
        .sameScreen:         resb 1
        .unused:             resb 1

    XEvent_MotionNotify:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .timestamp:          resd 1
        .root:               resd 1
        .event:              resd 1
        .child:              resd 1
        .rootX:              resw 1
        .rootY:              resw 1
        .eventX:             resw 1
        .eventY:             resw 1
        .state:              resw 1
        .sameScreen:         resb 1
        .unused:             resb 1

    XEvent_EnterNotify:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .timestamp:          resd 1
        .root:               resd 1
        .event:              resd 1
        .child:              resd 1
        .rootX:              resw 1
        .rootY:              resw 1
        .eventX:             resw 1
        .eventY:             resw 1
        .state:              resw 1
        .mode:               resb 1
        .flag:               resb 1 ;0b01 = sameScreen, 0b10 = focus

    XEvent_LeaveNotify:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .timestamp:          resd 1
        .root:               resd 1
        .event:              resd 1
        .child:              resd 1
        .rootX:              resw 1
        .rootY:              resw 1
        .eventX:             resw 1
        .eventY:             resw 1
        .state:              resw 1
        .mode:               resb 1
        .flag:               resb 1 ;0b01 = sameScreen, 0b10 = focus

    XEvent_FocusIn:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .mode:               resb 1
        .unused:             resb 23

    XEvent_FocusOut:
        .detail:             resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .mode:               resb 1
        .unused:             resb 23

    XEvent_KeymapNotify:
        .keys:               resb 31

    XEvent_Expose:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .window:             resd 1
        .x:                  resw 1
        .y:                  resw 1
        .width:              resw 1
        .height:             resw 1
        .count:              resw 1
        .unused_02:          resb 14

    XEvent_GraphicsExposure:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .drawable:           resd 1
        .x:                  resw 1
        .y:                  resw 1
        .width:              resw 1
        .height:             resw 1
        .minorOpcode:        resw 1
        .count:              resw 1
        .majorOpcode:        resb 1
        .unused_02:          resb 11

    XEvent_NoExposure:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .drawable:           resd 1
        .minorOpcode:        resw 1
        .majorOpcode:        resb 1
        .unused_02:          resb 21

    XEvent_VisibilityNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .window:             resd 1
        .state:              resb 1
        .unused_02:          resb 23

    XEvent_CreateNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .parent:             resd 1
        .window:             resd 1
        .x:                  resw 1
        .y:                  resw 1
        .width:              resw 1
        .height:             resw 1
        .borderWidth:        resw 1
        .overrideRedirect:   resb 1
        .unused_02:          resb 9

    XEvent_DestroyNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .window:             resd 1
        .unused_02:          resb 20

    XEvent_UnmapNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .window:             resd 1
        .fromConfigure:      resb 1
        .unused_02:          resb 19

    XEvent_MapNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .window:             resd 1
        .overrideRedirect:   resb 1
        .unused_02:          resb 19

    XEvent_MapRequest:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .parent:             resd 1
        .window:             resd 1
        .unused_02:          resb 20

    XEvent_ReparentNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .window:             resd 1
        .parent:             resd 1
        .x:                  resw 1
        .y:                  resw 1
        .overrideRedirect:   resb 1
        .unused_02:          resb 11

    XEvent_ConfigureNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .window:             resd 1
        .aboveSibling:       resd 1
        .x:                  resw 1
        .y:                  resw 1
        .width:              resw 1
        .height:             resw 1
        .borderWidth:        resw 1
        .overrideRedirect:   resb 1
        .unused_02:          resb 5

    XEvent_ConfigureRequest:
        .stackMode:          resb 1
        .sequenceNumber:     resw 1
        .parent:             resd 1
        .window:             resd 1
        .sibling:            resd 1
        .x:                  resw 1
        .y:                  resw 1
        .width:              resw 1
        .height:             resw 1
        .borderWidth:        resw 1
        .valueMask:          resw 1
        .unused:             resb 4

    XEvent_GravityNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .window:             resd 1
        .x:                  resw 1
        .y:                  resw 1
        .unused_02:          resb 16

    XEvent_ResizeRequest:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .window:             resd 1
        .width:              resw 1
        .height:             resw 1
        .unused_02:          resb 20

    XEvent_CirculateNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .event:              resd 1
        .window:             resd 1
        .unused_02:          resd 1
        .place:              resb 1
        .unused_03:          resb 15

    XEvent_CirculateRequest:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .parent:             resd 1
        .window:             resd 1
        .unused_02:          resd 1
        .place:              resb 1
        .unused_03:          resb 15

    XEvent_PropertyNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .window:             resd 1
        .atom:               resd 1
        .time:               resd 1
        .state:              resb 1
        .unused_02:          resb 15

    XEvent_SelectionClear:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .time:               resd 1
        .owner:              resd 1
        .selection:          resd 1
        .unused_02:          resb 16

    XEvent_SelectionRequest:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .time:               resd 1
        .owner:              resd 1
        .requestor:          resd 1
        .selection:          resd 1
        .target:             resd 1
        .property:           resd 1
        .unused_02:          resb 4

    XEvent_SelectionNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .time:               resd 1
        .requestor:          resd 1
        .selection:          resd 1
        .target:             resd 1
        .property:           resd 1
        .unused_02:          resb 8

    XEvent_ColormapNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .window:             resd 1
        .colormap:           resd 1
        .new:                resb 1
        .state:              resb 1
        .unused_02:          resb 18

    XEvent_ClientMessage:
        .format:             resb 1
        .sequenceNumber:     resw 1
        .window:             resd 1
        .type:               resd 1
        .data:               resb 20

    XEvent_MappingNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .request:            resb 1
        .firstKeycode:       resb 1
        .count:              resb 1
        .unused_02:          resb 25

    XEvent_unknown:          resb 31

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
        .requestLength:      dw 23 ;( 8 + n )
        .wid:                dd 0
        .parent:             dd 0
        .x:                  dw 100
        .y:                  dw 100
        .width:              dw 640
        .height:             dw 480
        .borderWidth:        dw 4
        .class:              dw _InputOutput_
        .visual:             dd _CopyFromParent_
        .valueMask:          dd 0b00000000000000000111111111111111
        .backgroundPixmap:   dd _ParentRelative_
        .backgroundPixel:    dd 0
        .borderPixmap:       dd _CopyFromParent_
        .borderPixel:        dd 0
        .bitGravity:         dd _Forget_
        .winGravity:         dd _NorthWest_
        .backingStore:       dd _NotUseful_
        .backingPlanes:      dd 0xffffffff
        .backingPixel:       dd 0x00000000
        .overrideRedirect:   dd _False_
        .saveUnder:          dd _False_
        .eventMask:          dd 0b00000001111111111111111111111111
        .doNotPropagateMask: dd 0x00000000
        .colorMap:           dd _CopyFromParent_
        .cursor:             dd _None_
    mainWindow_size:         dd ($ - mainWindow)

    mapWindow:
        .opcode:             db _REQUEST_MAPWINDOW_
        .unused:             db 0
        .requestLength:      dw 2
        .wid:                dd 0

    evtmsg_KeyPress:         db "Received KeyPress event        ",0x0a
    evtmsg_KeyRelease:       db "Received KeyRelease event      ",0x0a
    evtmsg_ButtonPress:      db "Received ButtonPress event     ",0x0a
    evtmsg_ButtonRelease:    db "Received ButtonRelease event   ",0x0a
    evtmsg_MotionNotify:     db "Received MotionNotify event    ",0x0a
    evtmsg_EnterNotify:      db "Received EnterNotify event     ",0x0a
    evtmsg_LeaveNotify:      db "Received LeaveNotify event     ",0x0a
    evtmsg_FocusIn:          db "Received FocusIn event         ",0x0a
    evtmsg_FocusOut:         db "Received FocusOut event        ",0x0a
    evtmsg_KeymapNotify:     db "Received KeymapNotify event    ",0x0a
    evtmsg_Expose:           db "Received Expose event          ",0x0a
    evtmsg_GraphicsExposure: db "Received GraphicsExposure event",0x0a
    evtmsg_NoExposure:       db "Received NoExposure event      ",0x0a
    evtmsg_VisibilityNotify: db "Received VisibilityNotify event",0x0a
    evtmsg_CreateNotify:     db "Received CreateNotify event    ",0x0a
    evtmsg_DestroyNotify:    db "Received DestroyNotify event   ",0x0a
    evtmsg_UnmapNotify:      db "Received UnmapNotify event     ",0x0a
    evtmsg_MapNotify:        db "Received MapNotify event       ",0x0a
    evtmsg_MapRequest:       db "Received MapRequest event      ",0x0a
    evtmsg_ReparentNotify:   db "Received ReparentNotify event  ",0x0a
    evtmsg_ConfigureNotify:  db "Received ConfigureNotify event ",0x0a
    evtmsg_ConfigureRequest: db "Received ConfigureRequest event",0x0a
    evtmsg_GravityNotify:    db "Received GravityNotify event   ",0x0a
    evtmsg_ResizeRequest:    db "Received ResizeRequest event   ",0x0a
    evtmsg_CirculateNotify:  db "Received CirculateNotify event ",0x0a
    evtmsg_CirculateRequest: db "Received CirculateRequest event",0x0a
    evtmsg_PropertyNotify:   db "Received PropertyNotify event  ",0x0a
    evtmsg_SelectionClear:   db "Received SelectionClear event  ",0x0a
    evtmsg_SelectionRequest: db "Received SelectionRequest event",0x0a
    evtmsg_SelectionNotify:  db "Received SelectionNotify event ",0x0a
    evtmsg_ColormapNotify:   db "Received ColormapNotify event  ",0x0a
    evtmsg_ClientMessage:    db "Received ClientMessage event   ",0x0a
    evtmsg_MappingNotify:    db "Received MappingNotify event   ",0x0a
    evtmsg_unknown:          db "Received unknown event         ",0x0a
    evtmsg_len:              dd 32
