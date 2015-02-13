;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_XRequests.inc
;
; This header file contains structures used for requesting X Server.
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


section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Structure for the main window. The program will send this
    ; structure to the X Server to create the main window.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    mainWindow:
        .opcode:             db _REQUEST_CreateWindow_
        .depth:              db _CopyFromParent_
        .requestLength:      dw 23 ;( 8 + n ), n = no. of valuemask
        .wid:                dd 0  ;will be filled at runtime
        .parent:             dd 0  ;will be filled at runtime
        .x:                  dw 100
        .y:                  dw 100
        .width:              dw 640
        .height:             dw 480
        .borderWidth:        dw 4
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
        .valueMask:          dd 0b00000000000000000111111111111111

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
                                ;bit 18 = ResizeRedirect
                                ;bit 19 = SubstructureNotify
                                ;bit 20 = SubstructureRedirect
                                ;bit 21 = FocusChange
                                ;bit 22 = PropertyChange
                                ;bit 23 = ColormapChange
                                ;bit 24 = OwnerGrabButton
                                ;bit 25 - 31 = unused but must zero
        .eventMask:          dd 0b1111111111111111111111111

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
    ; Structures setWindowDeleteMsg, setWindowName,
    ; setWindowSizeHints, and setWindowManagerHints are
    ; used to setup the window manager properties.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    setWindowDeleteMsg:
        .opcode:             db _REQUEST_ChangeProperty_
        .mode:               db _Replace_
        .requestLength:      dw 7
        .window:             dd 0
        .property:           dd 0x0000012d ;_XA_???_
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
        .min_width:          dd 320
        .min_height:         dd 240

        ;maximum size
        .max_width:          dd 800
        .max_height:         dd 600

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

