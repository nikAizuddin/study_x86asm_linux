;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_XRequests.inc
;
; This header file contains structures used for requesting X Server,
; and also contains the main program structures.
; Note: "unused" variables are used for padding purpose.
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
    ; This structure is used to stores the value returned by
    ; InternAtom() request.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    InternAtom_reply:
        .status:             resb 1
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .length:             resd 1
        .atom:               resd 1
        .unused_02:          resb 20


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This structure is used to check the request status.
    ; If our request fail, the server will send the reasons
    ; why the request was a failure.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    requestStatus:
        .success:            resb 1
        .code:               resb 1
        .sequenceNumber:     resw 1
        .ridBad:             resd 1 ;if success == 0
        .minorOpcode:        resw 1
        .majorOpcode:        resb 1
        .unused_02:          resb 21


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; These variables are used to handle 640*480*4 32bit image.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    testimage_fd:            resd 1
    testimage_dataPixel:     resb 1228800
    temporary_dataPixel:     resb 1228800


section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Structure for the main window. The program will send this
    ; structure to the X Server to create the main window.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mainWindow:
        .opcode:             db _REQUEST_CreateWindow_
        .depth:              db 24;24 ;_CopyFromParent_
        .requestLength:      dw 23 ;( 8 + n ), n = no. of valuemask
        .wid:                dd 0  ;will be filled at runtime
        .parent:             dd 0  ;will be filled at runtime
        .x:                  dw 100
        .y:                  dw 100
        .width:              dw 640
        .height:             dw 480
        .borderWidth:        dw 0
        .class:              dw _InputOutput_
        .visual:             dd _CopyFromParent_

                                ;bit  0 = background-pixmap
                                ;bit  1 = background-pixel
                                ;bit  2 = border-pixmap
                                ;bit  3 = border-pixel
                                ;bit  4 = bit-gravity
                                ;bit  5 = win-gravity
                                ;bit  6 = backing-store
                                ;bit  7 = backing-planes
                                ;bit  8 = backing-pixel
                                ;bit  9 = override-redirect
                                ;bit 10 = save-under
                                ;bit 11 = event-mask
                                ;bit 12 = do-not-propagate-mask
                                ;bit 13 = colormap
                                ;bit 14 = cursor
        .valueMask:          dd 0b111111111111111

        .backgroundPixmap:   dd _ParentRelative_
        .backgroundPixel:    dd 0 ;will be filled at runtime
        .borderPixmap:       dd _CopyFromParent_
        .borderPixel:        dd 0 ;will be filled at runtime
        .bitGravity:         dd _Forget_
        .winGravity:         dd _NorthWest_
        .backingStore:       dd _NotUseful_
        .backingPlanes:      dd 0xffffffff
        .backingPixel:       dd 0x00000000
        .overrideRedirect:   dd _False_
        .saveUnder:          dd _False_

                                ;bit  0 = KeyPress
                                ;bit  1 = KeyRelease
                                ;bit  2 = ButtonPress
                                ;bit  3 = ButtonRelease
                                ;bit  4 = EnterWindow
                                ;bit  5 = LeaveWindow
                                ;bit  6 = PointerMotion
                                ;bit  7 = PointerMotionHint
                                ;bit  8 = Button1Motion
                                ;bit  9 = Button2Motion
                                ;bit 10 = Button3Motion
                                ;bit 11 = Button4Motion
                                ;bit 12 = Button5Motion
                                ;bit 13 = ButtonMotion
                                ;bit 14 = KeymapState
                                ;bit 15 = Exposure
                                ;bit 16 = VisibilityChange
                                ;bit 17 = StructureNotify
                                ;bit 18 = ResizeRedirect (OFF)
                                ;bit 19 = SubstructureNotify
                                ;bit 20 = SubstructureRedirect
                                ;bit 21 = FocusChange
                                ;bit 22 = PropertyChange
                                ;bit 23 = ColormapChange
                                ;bit 24 = OwnerGrabButton
                                ;bit 25 - 31 = unused but must zero
        .eventMask:          dd 0b1111110111111111111111111

                                ;bit  0 = unused but must zero
                                ;bit  1 = unused but must zero
                                ;bit  2 = ButtonPress
                                ;bit  3 = ButtonRelease
                                ;bit  4 = EnterWindow
                                ;bit  5 = LeaveWindow
                                ;bit  6 = PointerMotion
                                ;bit  7 = PointerMotionHint
                                ;bit  8 = Button1Motion
                                ;bit  9 = Button2Motion
                                ;bit 10 = Button3Motion
                                ;bit 11 = Button4Motion
                                ;bit 12 = Button5Motion
                                ;bit 13 = ButtonMotion
                                ;bit 14 = KeymapState
                                ;bit 15 - 31 = unused but must zero
        .doNotPropagateMask: dd 0b000000000000000

        .colorMap:           dd _CopyFromParent_
        .cursor:             dd _None_
    mainWindow_size:         dd ($ - mainWindow)


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Structure that is used to request GC.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    graphicContext:
        .opcode:             db _REQUEST_CreateGC_
        .unused_01:          db 0
        .requestLength:      dw 4
        .cid:                dd 0
        .drawable:           dd 0 ;drawable on which window ID ?

                                ;bit  0 = function
                                ;bit  1 = plane-mask
                                ;bit  2 = foreground
                                ;bit  3 = background
                                ;bit  4 = line-width
                                ;bit  5 = line-style
                                ;bit  6 = cap-style
                                ;bit  7 = join-style
                                ;bit  8 = fill-style
                                ;bit  9 = fill-rule
                                ;bit 10 = tile
                                ;bit 11 = stipple
                                ;bit 12 = tile-stipple-x-origin
                                ;bit 13 = tile-stipple-y-origin
                                ;bit 14 = font
                                ;bit 15 = subwindow-mode
                                ;bit 16 = graphics-exposures
                                ;bit 17 = clip-x-origin
                                ;bit 18 = clip-y-origin
                                ;bit 19 = clip-mask
                                ;bit 20 = dash-offset
                                ;bit 21 = dashes
                                ;bit 22 = arc-mode
        .valueMask:          dd 0b00000000000000000000000


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Use this structure to draw image onto pixmap or window
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    putImage:
        .opcode:             db _REQUEST_PutImage_
        .format:             db 2
        .requestLength:      dw 6406 ;16390 ;min=6
        .drawable:           dd 0
        .gc:                 dd 0
        .width:              dw 640 ;128
        .height:             dw 10  ;128
        .dstX:               dw 0
        .dstY:               dw 0
        .leftPad:            db 0
        .depth:              db 24
        .unused:             dw 0
        ;.data = testimage_dataPixel
                             

    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This structure is used for mapping window request.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mapWindow:
        .opcode:             db _REQUEST_MapWindow_
        .unused:             db 0
        .requestLength:      dw 2
        .wid:                dd 0 ;will be filled at runtime


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This structure is used to destroy window
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    destroyWindow:
        .opcode:             db 4
        .unused:             db 0
        .requestLength:      dw 2
        .window:             dd 0


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; This structure is used to request WM_DELETE_WINDOW atom
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    getWMDeleteMessage:
        .opcode:             db _REQUEST_InternAtom_
        .onlyIfExist:        db 0
        .requestLength:      dw 6 ;sizeof this / 4 
        .lengthOfName:       dw 16
        .unused:             dw 0
        .name:               db "WM_DELETE_WINDOW"


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Use this structure to request WM_PROTOCOLS property.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    getWMProtocols:
        .opcode:             db _REQUEST_InternAtom_
        .onlyIfExist:        db 0
        .requestLength:      dw 5 ;sizeof this / 4 
        .lengthOfName:       dw 12
        .unused:             dw 0
        .name:               db "WM_PROTOCOLS"


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Use this structure to request CreatePixmap.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    testimage_pixmap:
        .opcode:             db _REQUEST_CreatePixmap_
        .depth:              db 24
        .requestLength:      dw 4
        .pid:                dd 0
        .drawable:           dd 0
        .width:              dw 640
        .height:             dw 480


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Use this structure to copy image from testimage_pixmap
    ; to mainWindow
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    copyArea:
        .opcode:             db _REQUEST_CopyArea_
        .unused:             db 0
        .requestLength:      dw 7
        .srcDrawable:        dd 0
        .dstDrawable:        dd 0
        .gc:                 dd 0
        .srcX:               dw 0
        .srcY:               dw 0
        .dstX:               dw 0
        .dstY:               dw 0
        .width:              dw 640
        .height:             dw 480


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Structures setWindowDeleteMsg, setWindowName,
    ; setWindowSizeHints, and setWindowManagerHints are
    ; used to setup the window manager properties.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    setWindowDeleteMsg:
        .opcode:             db _REQUEST_ChangeProperty_
        .mode:               db _Replace_
        .requestLength:      dw 7
        .window:             dd 0
        .property:           dd 0 ;will be WM_PROTOCOLS
        .type:               dd _XA_ATOM_
        .format:             db 32
        .unused_01:          db 0,0,0
        .lengthOfData:       dd 1
        .data:               dd 0


    setWindowName:
        .opcode:             db _REQUEST_ChangeProperty_
        .mode:               db _Replace_
        .requestLength:      dw 11 ;11 = 44 / 4
        .window:             dd 0
        .property:           dd _XA_WM_NAME_
        .type:               dd _XA_STRING_
        .format:             db 8
        .unused_01:          db 0,0,0
        .lengthOfData:       dd 19
        .data:               db "Simple Plain Window"
        .unused_02:          db 0


    setWindowSizeHints:
        .opcode:             db _REQUEST_ChangeProperty_
        .mode:               db _Replace_
        .requestLength:      dw 24
        .window:             dd 0
        .property:           dd _XA_WM_NORMAL_HINTS_
        .type:               dd _XA_WM_SIZE_HINTS_
        .format:             db 32
        .unused:             db 0,0,0
        .lengthOfData:       dd 18

        ; *** XSizeHint structure as the data ***

                                ;bit 0 - 1 = unused
                                ;bit  2 = position
                                ;bit  3 = size
                                ;bit  4 = minimum size
                                ;bit  5 = maximum size
                                ;bit  7 = minimum aspect ratio
                                ;bit  8 = maximum aspect ratio
                                ;bit  9 = ???
                                ;bit 10 = ???
        .flags:              dd 0b00000000000000000000000000110100

        ;position
        .x:                  dd 0
        .y:                  dd 0

        ;size
        .width:              dd 0
        .height:             dd 0

        ;minimum size
        .min_width:          dd 640
        .min_height:         dd 480

        ;maximum size
        .max_width:          dd 640
        .max_height:         dd 480

        ;???
        .width_inc:          dd 0
        .height_inc:         dd 0

        ;minimum aspect ratio
        .minAspectNume:      dd 0 ;numerator
        .minAspectDenom:     dd 0 ;denominator

        ;maximum aspect ratio
        .maxAspectNume:      dd 0 ;numerator
        .maxAspectDenom:     dd 0 ;denominator

        ;???
        .base_width:         dd 0
        .base_height:        dd 0

        ;???
        .win_gravity:        dd 0

    setWindowManagerHints:
        .opcode:             db _REQUEST_ChangeProperty_
        .mode:               db _Replace_
        .requestLength:      dw 15
        .window:             dd 0
        .property:           dd _XA_WM_HINTS_
        .type:               dd _XA_WM_HINTS_
        .format:             db 32
        .unused:             db 0,0,0
        .lengthOfData:       dd 9

        ; *** XWMHints structure as the data ***

                                ;bit  0 = input
                                ;bit  1 = initial_state
                                ;bit  2 = icon_pixmap
                                ;bit  3 = icon_window
                                ;bit  4 = icon_x and icon_y
                                ;bit  5 = icon_mask
                                ;bit  6 = window_group
        .flags:              dd 0b0000011

        .input:              dd _TRUE_ ;allow keyboard input
        .initial_state:      dd _NormalState_
        .icon_pixmap:        dd 0
        .icon_window:        dd 0
        .icon_x:             dd 0
        .icon_y:             dd 0
        .icon_mask:          dd 0
        .window_group:       dd 0

