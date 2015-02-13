;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; data_strings.inc
;
; This header file containts structures.
;
;=====================================================================

section .data

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
    evtmsg_len:              dd 32
