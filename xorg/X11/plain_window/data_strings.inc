;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_strings.inc
;
; This header file contains strings.
;
;=====================================================================

section .data


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; These strings will be printed when certain events are
    ; triggered.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
    evtmsg_MappingNotify:    db "Received MappingNotify event   ",0x0a
    evtmsg_ClientMessage:    db "Received ClientMessage event   ",0x0a
    evtmsg_len:              dd 32


    msg_KeyPress_Enter:      db " -> key 'Enter' is pressed     ",0x0a
    msg_KeyPress_Space:      db " -> key 'Space' is pressed     ",0x0a
    msg_KeyPress_LShift:     db " -> key 'LShift' is pressed    ",0x0a
    msg_KeyPress_RShift:     db " -> key 'RShift' is pressed    ",0x0a
    msg_KeyPress_LCtrl:      db " -> key 'LCtrl' is pressed     ",0x0a
    msg_KeyPress_RCtrl:      db " -> key 'RCtrl' is pressed     ",0x0a
    msg_KeyPress_LAlt:       db " -> key 'LAlt' is pressed      ",0x0a
    msg_KeyPress_RAlt:       db " -> key 'RAlt' is pressed      ",0x0a

    msg_KeyPress_1:          db " -> key '1' is pressed         ",0x0a
    msg_KeyPress_2:          db " -> key '2' is pressed         ",0x0a
    msg_KeyPress_3:          db " -> key '3' is pressed         ",0x0a
    msg_KeyPress_4:          db " -> key '4' is pressed         ",0x0a
    msg_KeyPress_5:          db " -> key '5' is pressed         ",0x0a
    msg_KeyPress_6:          db " -> key '6' is pressed         ",0x0a
    msg_KeyPress_7:          db " -> key '7' is pressed         ",0x0a
    msg_KeyPress_8:          db " -> key '8' is pressed         ",0x0a
    msg_KeyPress_9:          db " -> key '9' is pressed         ",0x0a
    msg_KeyPress_0:          db " -> key '0' is pressed         ",0x0a

    msg_KeyPress_Q:          db " -> key 'Q' is pressed         ",0x0a
    msg_KeyPress_W:          db " -> key 'W' is pressed         ",0x0a
    msg_KeyPress_E:          db " -> key 'E' is pressed         ",0x0a
    msg_KeyPress_R:          db " -> key 'R' is pressed         ",0x0a
    msg_KeyPress_T:          db " -> key 'T' is pressed         ",0x0a
    msg_KeyPress_Y:          db " -> key 'Y' is pressed         ",0x0a
    msg_KeyPress_U:          db " -> key 'U' is pressed         ",0x0a
    msg_KeyPress_I:          db " -> key 'I' is pressed         ",0x0a
    msg_KeyPress_O:          db " -> key 'O' is pressed         ",0x0a
    msg_KeyPress_P:          db " -> key 'P' is pressed         ",0x0a

    msg_KeyPress_A:          db " -> key 'A' is pressed         ",0x0a
    msg_KeyPress_S:          db " -> key 'S' is pressed         ",0x0a
    msg_KeyPress_D:          db " -> key 'D' is pressed         ",0x0a
    msg_KeyPress_F:          db " -> key 'F' is pressed         ",0x0a
    msg_KeyPress_G:          db " -> key 'G' is pressed         ",0x0a
    msg_KeyPress_H:          db " -> key 'H' is pressed         ",0x0a
    msg_KeyPress_J:          db " -> key 'J' is pressed         ",0x0a
    msg_KeyPress_K:          db " -> key 'K' is pressed         ",0x0a
    msg_KeyPress_L:          db " -> key 'L' is pressed         ",0x0a

    msg_KeyPress_Z:          db " -> key 'Z' is pressed         ",0x0a
    msg_KeyPress_X:          db " -> key 'X' is pressed         ",0x0a
    msg_KeyPress_C:          db " -> key 'C' is pressed         ",0x0a
    msg_KeyPress_V:          db " -> key 'V' is pressed         ",0x0a
    msg_KeyPress_B:          db " -> key 'B' is pressed         ",0x0a
    msg_KeyPress_N:          db " -> key 'N' is pressed         ",0x0a
    msg_KeyPress_M:          db " -> key 'M' is pressed         ",0x0a

    msg_KeyPress_Unknown:    db " -> Unknwon Key is pressed     ",0x0a
    msg_len:                 dd 32
