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

    XEventReply:
        .code:               resd 1

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

    XEvent_MappingNotify:
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .request:            resb 1
        .firstKeycode:       resb 1
        .count:              resb 1
        .unused_02:          resb 25

    XEvent_ClientMessage:
        .format:             resb 1
        .sequenceNumber:     resw 1
        .window:             resd 1
        .type:               resd 1
        .data:               resb 20

    InternAtom_reply:
        .status:             resb 1
        .unused_01:          resb 1
        .sequenceNumber:     resw 1
        .length:             resd 1
        .atom:               resd 1
        .unused_02:          resb 20
