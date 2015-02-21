;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; constants.inc
;
; This header file contains constant symbols.
;
;=====================================================================

; System call numbers
_SYSCALL_EXIT_          equ      1 ;exit the program
_SYSCALL_READ_          equ      3 ;read from fd or socket
_SYSCALL_WRITE_         equ      4 ;write to fd or socket
_SYSCALL_OPEN_          equ      5 ;open fd
_SYSCALL_CLOSE_         equ      6 ;close socket or fd
_SYSCALL_LSEEK_         equ     19 ;seek fd
_SYSCALL_ACCESS_        equ     33 ;check file permission
_SYSCALL_SOCKETCALL_    equ    102 ;main socketcall
_SYSCALL_WRITEV_        equ    146 ;multiple writing
_SYSCALL_POLL_          equ    168 ;check & wait socket events
_SYSCALL_FSTAT64_       equ    197 ;check file status & info
_SYSCALL_FCNTL64_       equ    221 ;configure socket

; Standard File Descriptors
_STDIN_                 equ      0
_STDOUT_                equ      1

; Whence values for LSEEK systemcall
_SEEK_SET_              equ      0
_SEEK_CUR_              equ      1
_SEEK_END_              equ      2

; Standard Boolean values
_TRUE_                  equ      1
_FALSE_                 equ      0

; Constant values for systemcall socketcall()
_CALL_SOCKET_           equ      1 ;create socket
_CALL_BIND_             equ      2 ;bind socket
_CALL_CONNECT_          equ      3 ;connect socket
_CALL_LISTEN_           equ      4 ;listen
_CALL_ACCEPT_           equ      5 ;accept request
_CALL_GETSOCKNAME_      equ      6 ;get socket name
_CALL_GETPEERNAME_      equ      7 ;get peer name
_CALL_SOCKETPAIR_       equ      8
_CALL_SEND_             equ      9 ;send data through socket
_CALL_RECV_             equ     10 ;receive data from socket
_CALL_SENDTO_           equ     11
_CALL_RECVFROM_         equ     12
_CALL_SHUTDOWN_         equ     13
_SOCK_STREAM_           equ      1 ;sequenced byte stream

; Constant values for socketcall shutdown()
_SHUT_RD_               equ      0
_SHUT_WR_               equ      1
_SHUT_RDWR_             equ      2

; Constant values for systemcall access()
_F_OK_                  equ      0 ;is file exist?
_X_OK_                  equ      1 ;check permission to exec
_W_OK_                  equ      2 ;check permission to write
_R_OK_                  equ      4 ;check permission to read

; Constant values for systemcall fcntl64()
_O_RDONLY_              equ 0q0000 ;read-only
_O_RDWR_                equ 0q0002 ;read and write
_O_NONBLOCK_            equ 0q4000 ;non-blocking
_F_GETFL_               equ      3 ;get file status flag
_F_SETFL_               equ      4 ;set file status flag
_F_SETFD_               equ      2 ;set fd flag
_FD_CLOEXEC_            equ      1 ;automatic close on exit

; Constant values for systemcall socketcall()
_PF_LOCAL_              equ      1 ;local protocol family
_AF_LOCAL_              equ      1 ;local address family
_IPPROTO_IP_            equ      0 ;dummy TCP protocol

; Constant values for systemcall poll()
_POLLIN_                equ  0x001 ;there is data to read
_POLLOUT_               equ  0x004 ;writing now will not block
_POLL_INFINITE_TIMEOUT_ equ     -1
_POLL_SHORT_TIMEOUT_    equ    100 ;100 milliseconds

; Constant values for XWindow
_InputOutput_           equ      1 ;window with input & output
_CopyFromParent_        equ      0 ;copy attributes from parent win.
_ParentRelative_        equ      1

; Constant values for X Window bit-gravity and win-gravity
_Unmap_                 equ      0
_Forget_                equ      0
_NorthWest_             equ      1
_North_                 equ      2
_NorthEast_             equ      3
_West_                  equ      4
_Center_                equ      5
_East_                  equ      6
_SouthWest_             equ      7
_South_                 equ      8
_SouthEast_             equ      9
_Static_                equ     10
_None_                  equ      0
_False_                 equ      0
_True_                  equ      1
_NotUseful_             equ      0
_WhenMapped_            equ      1
_Always_                equ      2

; Constant values for ChangeProperty request
_Replace_               equ      0
_Prepend_               equ      1
_Append_                equ      2
_NormalState_           equ      1

; Constant values for X Server Request Opcodes
_REQUEST_CreateWindow_   equ     1
_REQUEST_DestroyWindow_  equ     4
_REQUEST_MapWindow_      equ     8
_REQUEST_InternAtom_     equ    16
_REQUEST_ChangeProperty_ equ    18
_REQUEST_CreatePixmap_   equ    53
_REQUEST_FreePixmap_     equ    54
_REQUEST_CreateGC_       equ    55
_REQUEST_FreeGC_         equ    60
_REQUEST_ClearArea_      equ    61
_REQUEST_CopyArea_       equ    62
_REQUEST_PutImage_       equ    72

; Constant values ChangeProperty request
_XA_PRIMARY_            equ      1
_XA_SECONDARY_          equ      2
_XA_ARC_                equ      3
_XA_ATOM_               equ      4
_XA_BITMAP_             equ      5
_XA_CARDINAL_           equ      6
_XA_COLORMAP_           equ      7
_XA_CURSOR_             equ      8
_XA_CUT_BUFFER0_        equ      9
_XA_CUT_BUFFER1_        equ     10
_XA_CUT_BUFFER2_        equ     11
_XA_CUT_BUFFER3_        equ     12
_XA_CUT_BUFFER4_        equ     13
_XA_CUT_BUFFER5_        equ     14
_XA_CUT_BUFFER6_        equ     15
_XA_CUT_BUFFER7_        equ     16
_XA_DRAWABLE_           equ     17
_XA_FONT_               equ     18
_XA_INTEGER_            equ     19
_XA_PIXMAP_             equ     20
_XA_POINT_              equ     21
_XA_RECTANGLE_          equ     22
_XA_RESOURCE_MANAGER_   equ     23
_XA_RGB_COLOR_MAP_      equ     24
_XA_RGB_BEST_MAP_       equ     25
_XA_RGB_BLUE_MAP_       equ     26
_XA_RGB_DEFAULT_MAP_    equ     27
_XA_RGB_GRAY_MAP_       equ     28
_XA_RGB_GREEN_MAP_      equ     29
_XA_RGB_RED_MAP_        equ     30
_XA_STRING_             equ     31
_XA_VISUALID_           equ     32
_XA_WINDOW_             equ     33
_XA_WM_COMMAND_         equ     34
_XA_WM_HINTS_           equ     35
_XA_WM_CLIENT_MACHINE_  equ     36
_XA_WM_ICON_NAME_       equ     37
_XA_WM_ICON_SIZE_       equ     38
_XA_WM_NAME_            equ     39
_XA_WM_NORMAL_HINTS_    equ     40
_XA_WM_SIZE_HINTS_      equ     41
_XA_WM_ZOOM_HINTS_      equ     42
_XA_MIN_SPACE_          equ     43
_XA_NORM_SPACE_         equ     44
_XA_MAX_SPACE_          equ     45
_XA_END_SPACE_          equ     46
_XA_SUPERSCRIPT_X_      equ     47
_XA_SUPERSCRIPT_Y_      equ     48
_XA_SUBSCRIPT_X_        equ     49
_XA_SUBSCRIPT_Y_        equ     50
_XA_UNDERLINE_POSITION_ equ     51
_XA_UNDERLINE_THICKNESS_ equ    52
_XA_STRIKEOUT_ASCENT_   equ     53
_XA_STRIKEOUT_DESCENT_  equ     54
_XA_ITALIC_ANGLE_       equ     55
_XA_X_HEIGHT_           equ     56
_XA_QUAD_WIDTH_         equ     57
_XA_WEIGHT_             equ     58
_XA_POINT_SIZE_         equ     59
_XA_RESOLUTION_         equ     60
_XA_COPYRIGHT_          equ     61
_XA_NOTICE_             equ     62
_XA_FONT_NAME_          equ     63
_XA_FAMILY_NAME_        equ     64
_XA_FULL_NAME_          equ     65
_XA_CAP_HEIGHT_         equ     66
_XA_WM_CLASS_           equ     67
_XA_WM_TRANSIENT_FOR_   equ     68
_XA_LAST_PREDEFINED_    equ     68

; Constant values for X Event received
_KeyPress_              equ      2 ;when key from Keyboard is pressed
_KeyRelease_            equ      3 ;when key from Keyboard is released
_ButtonPress_           equ      4 ;when mouse/touchpad is pressed
_ButtonRelease_         equ      5 ;when mouse/touchpad is released
_MotionNotify_          equ      6
_EnterNotify_           equ      7 ;when cursor enters the window
_LeaveNotify_           equ      8 ;when cursor leaves the window
_FocusIn_               equ      9 ;when window becomes focused
_FocusOut_              equ     10 ;when window is no longer in focus
_KeymapNotify_          equ     11
_Expose_                equ     12 ;when the window is overlapped
_GraphicsExposure_      equ     13
_NoExposure_            equ     14
_VisibilityNotify_      equ     15
_CreateNotify_          equ     16
_DestroyNotify_         equ     17
_UnmapNotify_           equ     18
_MapNotify_             equ     19
_MapRequest_            equ     20
_ReparentNotify_        equ     21
_ConfigureNotify_       equ     22
_ConfigureRequest_      equ     23
_GravityNotify_         equ     24
_ResizeRequest_         equ     25
_CirculateNotify_       equ     26
_CirculateRequest_      equ     27
_PropertyNotify_        equ     28
_SelectionClear_        equ     29
_SelectionRequest_      equ     30
_SelectionNotify_       equ     31
_ColormapNotify_        equ     32
_ClientMessage_         equ     33 ;unused
_MappingNotify_         equ     34

; Constant values for Keyboard KeyCode
_KEY_ENTER_             equ   0x24
_KEY_SPACE_             equ   0x41
_KEY_LSHIFT_            equ   0x32
_KEY_RSHIFT_            equ   0x3e
_KEY_LCTRL_             equ   0x25
_KEY_RCTRL_             equ   0x69
_KEY_LALT_              equ   0x40
_KEY_RALT_              equ   0x6c
_KEY_F1_                equ   0x43
_KEY_1_                 equ   0x0a
_KEY_2_                 equ   0x0b
_KEY_3_                 equ   0x0c
_KEY_4_                 equ   0x0d
_KEY_5_                 equ   0x0e
_KEY_6_                 equ   0x0f
_KEY_7_                 equ   0x10
_KEY_8_                 equ   0x11
_KEY_9_                 equ   0x12
_KEY_0_                 equ   0x13
_KEY_Q_                 equ   0x18
_KEY_W_                 equ   0x19
_KEY_E_                 equ   0x1a
_KEY_R_                 equ   0x1b
_KEY_T_                 equ   0x1c
_KEY_Y_                 equ   0x1d
_KEY_U_                 equ   0x1e
_KEY_I_                 equ   0x1f
_KEY_O_                 equ   0x20
_KEY_P_                 equ   0x21
_KEY_A_                 equ   0x26
_KEY_S_                 equ   0x27
_KEY_D_                 equ   0x28
_KEY_F_                 equ   0x29
_KEY_G_                 equ   0x2a
_KEY_H_                 equ   0x2b
_KEY_J_                 equ   0x2c
_KEY_K_                 equ   0x2d
_KEY_L_                 equ   0x2e
_KEY_Z_                 equ   0x34
_KEY_X_                 equ   0x35
_KEY_C_                 equ   0x36
_KEY_V_                 equ   0x37
_KEY_B_                 equ   0x38
_KEY_N_                 equ   0x39
_KEY_M_                 equ   0x3a

; Constant values for image information
_IMG_WIDTH_             equ    640 ;ONLY CHANGE THIS VALUE!
_IMG_HEIGHT_            equ    480 ;ONLY CHANGE THIS VALUE!
_IMG_NCHANNELS_         equ      4
_IMG_UPLOAD_SIZE_       equ (_IMG_WIDTH_*10*_IMG_NCHANNELS_)
_PUTIMAGE_REQ_LEN_      equ ((_IMG_UPLOAD_SIZE_/4) + 6)
_COLUMNSIZE_32_         equ (_IMG_NCHANNELS_*4)
_ROWSIZE_32_            equ (_IMG_WIDTH_*_COLUMNSIZE_32_)
_COLUMNSIZE_8_          equ (_IMG_NCHANNELS_*1)
_ROWSIZE_8_             equ (_IMG_WIDTH_*_COLUMNSIZE_8_)

; Constant values for image processing
_MEANBOX_WIDTH_         equ      9
_MEANBOX_CENTER_        equ ((_MEANBOX_WIDTH_-1) / 2)
_MEANBOX_AREA_          equ __float32__(81.0) ;_MEANBOX_WIDTH_^2
