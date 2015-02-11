;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; constants.inc
;
; This header file containts constant symbols.
;
;=====================================================================

; System call numbers
_SYSCALL_EXIT_          equ      1 ;exit the program
_SYSCALL_READ_          equ      3 ;read from fd or socket
_SYSCALL_WRITE_         equ      4 ;write to fd or socket
_SYSCALL_OPEN_          equ      5 ;open fd
_SYSCALL_CLOSE_         equ      6 ;close socket or fd
_SYSCALL_ACCESS_        equ     33 ;check file permission
_SYSCALL_SOCKETCALL_    equ    102 ;main socketcall
_SYSCALL_WRITEV_        equ    146 ;multiple writing
_SYSCALL_POLL_          equ    168 ;check & wait socket events
_SYSCALL_FSTAT64_       equ    197 ;check file status & info
_SYSCALL_FCNTL64_       equ    221 ;configure socket

; Standard File Descriptors
_STDIN_                 equ      0
_STDOUT_                equ      1

; Constant values for systemcall socketcall()
_CALL_SOCKET_           equ      1 ;create socket
_CALL_CONNECT_          equ      3 ;connect socket
_CALL_RECV_             equ     10 ;receive data from socket
_SOCK_STREAM_           equ      1 ;sequenced byte stream

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

; Constant values for X Server Request Opcodes
_REQUEST_CREATEWINDOW_  equ      1
_REQUEST_MAPWINDOW_     equ      8

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
_ClientMessage_         equ     33
_MappingNotify_         equ     34
