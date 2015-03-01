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


    msg_len:                 dd 32


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Message printed when certain key is pressed.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
    msg_KeyPress_Unknown:    db " -> Unknown Key is pressed     ",0x0a


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Message printed when certain key is released.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    msg_KeyRelease_Enter:    db " -> key 'Enter' is released    ",0x0a
    msg_KeyRelease_Space:    db " -> key 'Space' is released    ",0x0a
    msg_KeyRelease_LShift:   db " -> key 'LShift' is released   ",0x0a
    msg_KeyRelease_RShift:   db " -> key 'RShift' is released   ",0x0a
    msg_KeyRelease_LCtrl:    db " -> key 'LCtrl' is released    ",0x0a
    msg_KeyRelease_RCtrl:    db " -> key 'RCtrl' is released    ",0x0a
    msg_KeyRelease_LAlt:     db " -> key 'LAlt' is released     ",0x0a
    msg_KeyRelease_RAlt:     db " -> key 'RAlt' is released     ",0x0a
    msg_KeyRelease_1:        db " -> key '1' is released        ",0x0a
    msg_KeyRelease_2:        db " -> key '2' is released        ",0x0a
    msg_KeyRelease_3:        db " -> key '3' is released        ",0x0a
    msg_KeyRelease_4:        db " -> key '4' is released        ",0x0a
    msg_KeyRelease_5:        db " -> key '5' is released        ",0x0a
    msg_KeyRelease_6:        db " -> key '6' is released        ",0x0a
    msg_KeyRelease_7:        db " -> key '7' is released        ",0x0a
    msg_KeyRelease_8:        db " -> key '8' is released        ",0x0a
    msg_KeyRelease_9:        db " -> key '9' is released        ",0x0a
    msg_KeyRelease_0:        db " -> key '0' is released        ",0x0a
    msg_KeyRelease_Q:        db " -> key 'Q' is released        ",0x0a
    msg_KeyRelease_W:        db " -> key 'W' is released        ",0x0a
    msg_KeyRelease_E:        db " -> key 'E' is released        ",0x0a
    msg_KeyRelease_R:        db " -> key 'R' is released        ",0x0a
    msg_KeyRelease_T:        db " -> key 'T' is released        ",0x0a
    msg_KeyRelease_Y:        db " -> key 'Y' is released        ",0x0a
    msg_KeyRelease_U:        db " -> key 'U' is released        ",0x0a
    msg_KeyRelease_I:        db " -> key 'I' is released        ",0x0a
    msg_KeyRelease_O:        db " -> key 'O' is released        ",0x0a
    msg_KeyRelease_P:        db " -> key 'P' is released        ",0x0a
    msg_KeyRelease_A:        db " -> key 'A' is released        ",0x0a
    msg_KeyRelease_S:        db " -> key 'S' is released        ",0x0a
    msg_KeyRelease_D:        db " -> key 'D' is released        ",0x0a
    msg_KeyRelease_F:        db " -> key 'F' is released        ",0x0a
    msg_KeyRelease_G:        db " -> key 'G' is released        ",0x0a
    msg_KeyRelease_H:        db " -> key 'H' is released        ",0x0a
    msg_KeyRelease_J:        db " -> key 'J' is released        ",0x0a
    msg_KeyRelease_K:        db " -> key 'K' is released        ",0x0a
    msg_KeyRelease_L:        db " -> key 'L' is released        ",0x0a
    msg_KeyRelease_Z:        db " -> key 'Z' is released        ",0x0a
    msg_KeyRelease_X:        db " -> key 'X' is released        ",0x0a
    msg_KeyRelease_C:        db " -> key 'C' is released        ",0x0a
    msg_KeyRelease_V:        db " -> key 'V' is released        ",0x0a
    msg_KeyRelease_B:        db " -> key 'B' is released        ",0x0a
    msg_KeyRelease_N:        db " -> key 'N' is released        ",0x0a
    msg_KeyRelease_M:        db " -> key 'M' is released        ",0x0a
    msg_KeyRelease_Unknown:  db " -> Unknown Key is released    ",0x0a


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Path to ATT Database
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    path_s01_01:             db "att_faces/orl_faces/s1/1.pgm",0
    path_s01_02:             db "att_faces/orl_faces/s1/2.pgm",0
    path_s01_03:             db "att_faces/orl_faces/s1/3.pgm",0
    path_s01_04:             db "att_faces/orl_faces/s1/4.pgm",0
    path_s01_05:             db "att_faces/orl_faces/s1/5.pgm",0
    path_s02_01:             db "att_faces/orl_faces/s2/1.pgm",0
    path_s02_02:             db "att_faces/orl_faces/s2/2.pgm",0
    path_s02_03:             db "att_faces/orl_faces/s2/3.pgm",0
    path_s02_04:             db "att_faces/orl_faces/s2/4.pgm",0
    path_s02_05:             db "att_faces/orl_faces/s2/5.pgm",0
    path_s03_01:             db "att_faces/orl_faces/s3/1.pgm",0
    path_s03_02:             db "att_faces/orl_faces/s3/2.pgm",0
    path_s03_03:             db "att_faces/orl_faces/s3/3.pgm",0
    path_s03_04:             db "att_faces/orl_faces/s3/4.pgm",0
    path_s03_05:             db "att_faces/orl_faces/s3/5.pgm",0
    path_s04_01:             db "att_faces/orl_faces/s4/1.pgm",0
    path_s04_02:             db "att_faces/orl_faces/s4/2.pgm",0
    path_s04_03:             db "att_faces/orl_faces/s4/3.pgm",0
    path_s04_04:             db "att_faces/orl_faces/s4/4.pgm",0
    path_s04_05:             db "att_faces/orl_faces/s4/5.pgm",0
    path_s05_01:             db "att_faces/orl_faces/s5/1.pgm",0
    path_s05_02:             db "att_faces/orl_faces/s5/2.pgm",0
    path_s05_03:             db "att_faces/orl_faces/s5/3.pgm",0
    path_s05_04:             db "att_faces/orl_faces/s5/4.pgm",0
    path_s05_05:             db "att_faces/orl_faces/s5/5.pgm",0
    path_s06_01:             db "att_faces/orl_faces/s6/1.pgm",0
    path_s06_02:             db "att_faces/orl_faces/s6/2.pgm",0
    path_s06_03:             db "att_faces/orl_faces/s6/3.pgm",0
    path_s06_04:             db "att_faces/orl_faces/s6/4.pgm",0
    path_s06_05:             db "att_faces/orl_faces/s6/5.pgm",0
    path_s07_01:             db "att_faces/orl_faces/s7/1.pgm",0
    path_s07_02:             db "att_faces/orl_faces/s7/2.pgm",0
    path_s07_03:             db "att_faces/orl_faces/s7/3.pgm",0
    path_s07_04:             db "att_faces/orl_faces/s7/4.pgm",0
    path_s07_05:             db "att_faces/orl_faces/s7/5.pgm",0
    path_s08_01:             db "att_faces/orl_faces/s8/1.pgm",0
    path_s08_02:             db "att_faces/orl_faces/s8/2.pgm",0
    path_s08_03:             db "att_faces/orl_faces/s8/3.pgm",0
    path_s08_04:             db "att_faces/orl_faces/s8/4.pgm",0
    path_s08_05:             db "att_faces/orl_faces/s8/5.pgm",0


    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ; Error messages.
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    errmsg_socketCreate:     db "ERR: Can't create socket       ",0x0a
    errmsg_connect_XServer:  db "ERR: Can't connect to XServer  ",0x0a
    errmsg_set_nonBlocking:  db "ERR: Can't set to non-blocking ",0x0a
    errmsg_get_authStatus:   db "ERR: Can't get auth status     ",0x0a
    errmsg_authStatus:       db "ERR: Authentication failed     ",0x0a
    errmsg_createMainWindow: db "ERR: Can't create mainWindow   ",0x0a
    errmsg_len:              dd 32
