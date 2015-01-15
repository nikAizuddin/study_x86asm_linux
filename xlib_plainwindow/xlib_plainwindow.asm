;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
;                 Xlib Programming with x86 NASM
;
;                  Create a simple plain window
;
;---------------------------------------------------------------------
;
;         AUTHOR: Nik Mohamad Aizuddin bin Nik Azmi
;          EMAIL: nickaizuddin93@gmail.com
;   DATE CREATED: 12-JAN-2015
;
;       LANGUAGE: x86 Assembly Language
;      ASSEMBLER: NASM
;         SYNTAX: Intel
;   ARCHITECTURE: i386
;         KERNEL: Linux 32-bit
;         FORMAT: ELF32
;
;=====================================================================

extern XOpenDisplay
extern XDisplayName
extern XDefaultScreen
extern XDefaultScreenOfDisplay
extern XRootWindow
extern XWhitePixel
extern XBlackPixel
extern XCreateWindow
extern XMapWindow
extern XNextEvent
extern XCloseDisplay
extern XInternAtom
extern XSetWMProtocols
global _start

struc xserver
    .pDisplay:              resd 1
    .pScreen:               resd 1
    .screen_number:         resd 1
    .size:
endstruc

struc xswa
    .background_pixmap:     resd 1
    .background_pixel:      resd 1
    .border_pixmap:         resd 1
    .border_pixel:          resd 1
    .bit_gravity:           resd 1
    .win_gravity:           resd 1
    .backing_store:         resd 1
    .backing_planes:        resd 1
    .backing_pixel:         resd 1
    .save_under:            resd 1
    .event_mask:            resd 1
    .do_not_propagate_mask: resd 1
    .override_redirect:     resd 1
    .colormap:              resd 1
    .cursor:                resd 1
    .size:
endstruc

struc xwin
    .rootwindow:            resd 1
    .window:                resd 1
    .x:                     resd 1
    .y:                     resd 1
    .width:                 resd 1
    .height:                resd 1
    .border_width:          resd 1
    .depth:                 resd 1
    .class:                 resd 1
    .visual:                resd 1
    .valuemask:             resd 1
    .wm_delete_msg:         resd 1
    .atom_name:             resd 4
    .size:
endstruc

struc xevent
    .data:                  resd 24
    .size: 
endstruc

section .data

gui_t:

    .xserver_t:
        istruc xserver
            at xserver.pDisplay,           dd 0
            at xserver.pScreen,            dd 0
            at xserver.screen_number,      dd 0
        iend

    .xswa_t:
        istruc xswa
            at xswa.background_pixmap,     dd 0
            at xswa.background_pixel,      dd 0
            at xswa.border_pixmap,         dd 0
            at xswa.border_pixel,          dd 0
            at xswa.bit_gravity,           dd 0
            at xswa.win_gravity,           dd 0
            at xswa.backing_store,         dd 0
            at xswa.backing_planes,        dd 0
            at xswa.backing_pixel,         dd 0
            at xswa.save_under,            dd 0
            at xswa.event_mask,         dd 0b0000000000000000000001100
            at xswa.do_not_propagate_mask, dd 0
            at xswa.override_redirect,     dd 0
            at xswa.colormap,              dd 0
            at xswa.cursor,                dd 0
        iend

    .xwin_t:
        istruc xwin
            at xwin.rootwindow,            dd 0
            at xwin.window,                dd 0
            at xwin.x,                     dd 100
            at xwin.y,                     dd 100
            at xwin.width,                 dd 640
            at xwin.height,                dd 480
            at xwin.border_width,          dd 4
            at xwin.depth,                 dd 24
            at xwin.class,                 dd 1
            at xwin.visual,                dd 0
            at xwin.valuemask,             dd 0b000100000001010
            at xwin.wm_delete_msg,         dd 0
            at xwin.atom_name,             dd "WM_D"
                                           dd "ELET"
                                           dd "E_WI"
                                           dd "NDOW"
        iend

    .xevent_t:
        istruc xevent
            at xevent.data,       times 24 dd 0
        iend

section .text

_start:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Connect to x server
;
;   Display *XOpenDisplay(char *display_name)
;
;   Set display_name=NULL because we want the XOpenDisplay()
;   to connect to the server specified in the UNIX environment
;   DISPLAY variable. Use BASH command "echo $DISPLAY" to view
;   the current contents of the DISPLAY environment variable.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    esi, [gui_t.xserver_t]

    sub    esp, 4
    mov    dword [esp], 0
    call   XOpenDisplay
    add    esp, 4

    mov    [esi + xserver.pDisplay], eax

.b: ;################################################################

;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get default screen
;
;   int XDefaultScreen(Display *display)
;
;   This function should be used to retrieve the screen number in
;   applications that will use only a single screen.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    esi, [gui_t.xserver_t]

    sub    esp, 4
    mov    eax, [esi + xserver.pDisplay]
    mov    [esp], eax
    call   XDefaultScreen
    add    esp, 4

    mov    [esi + xserver.screen_number], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get pointer to the default
;
;   Screen *XDefaultScreenOfDisplay(Display *display)
;
;   This function returns a pointer to the default screen.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    esi, [gui_t.xserver_t]

    sub    esp, 4
    mov    eax, [esi + xserver.pDisplay]
    mov    [esp], eax
    call   XDefaultScreenOfDisplay
    add    esp, 4

    mov    [esi + xserver.pScreen], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Capture delete window message
;
;   Atom XInternAtom(Display *display,
;                    char    *atom_name,
;                    Bool     only_if_exists)
;
;   This function returns the atom identifier associated with the
;   specified atom_name string.
;
;   When a window is terminated, the Xlib sends some messages. So,
;   the purpose of calling this function, is we want to capture
;   the message. We do this by comparing the wm_delete_msg with
;   event message.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    esi, [gui_t.xserver_t]
    lea    edi, [gui_t.xwin_t]

    sub    esp, 12
    mov    eax, [esi + xserver.pDisplay]
    mov    ebx, gui_t
    lea    ebx, [gui_t.xwin_t + xwin.atom_name]
    xor    ecx, ecx
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    mov    [esp + 8], ecx
    call   XInternAtom
    add    esp, 12

    mov    [edi + xwin.wm_delete_msg], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get rootwindow
;
;   Window XRootWindow(Display *display, int screen_number)
;
;   We need a root window so that we can create the plain window.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    esi, [gui_t.xserver_t]
    lea    edi, [gui_t.xwin_t]

    sub    esp, 8
    mov    eax, [esi + xserver.pDisplay]
    mov    ebx, [esi + xserver.screen_number]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   XRootWindow
    add    esp, 8
    mov    [edi + xwin.rootwindow], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set window attribute background pixel color
;
;   unsigned long XBlackPixel(Display *display, int screen_number)
;
;   This function returns the black pixel value.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    esi, [gui_t.xserver_t]
    lea    edi, [gui_t.xswa_t]

    sub    esp, 8
    mov    eax, [esi + xserver.pDisplay]
    mov    ebx, [esi + xserver.screen_number]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   XBlackPixel
    add    esp, 8

    mov    [edi + xswa.background_pixel], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Set window attribute border pixel color:
;   unsigned long XWhitePixel(Display *display, int screen_number)
;
;   This function returns the white pixel value.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    lea    esi, [gui_t.xserver_t]
    lea    edi, [gui_t.xswa_t]

    sub    esp, 8
    mov    eax, [esi + xserver.pDisplay]
    mov    ebx, [esi + xserver.screen_number]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   XWhitePixel
    add    esp, 8

    mov    [edi + xswa.border_pixel], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Create a plain window
;
;   Window XCreateWindow(Display display,
;                        Window parent,
;                        int x,
;                        int y,
;                        unsigned int width,
;                        unsigned int height,
;                        unsigned int border_width,
;                        int depth,
;                        unsigned int class,
;                        Visual *visual,
;                        unsigned long valuemask,
;                        XSetWindowAttributes *attributes)
;
;   This function creates an unmapped subwindow for a specified
;   parent window. It returns the window ID of the created window
;   and causes X server to generate a CreateNotify event.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    sub    esp, 48 ;reserve 48 bytes

    lea    esi, [gui_t.xserver_t]
    mov    eax, [esi + xserver.pDisplay]

    lea    esi, [gui_t.xwin_t]
    mov    ebx, [esi + xwin.rootwindow]
    mov    ecx, [esi + xwin.x]
    mov    edx, [esi + xwin.y]
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx

    lea    esi, [gui_t.xwin_t]
    mov    eax, [esi + xwin.width]
    mov    ebx, [esi + xwin.height]
    mov    ecx, [esi + xwin.border_width]
    mov    edx, [esi + xwin.depth]
    mov    [esp + 16], eax
    mov    [esp + 20], ebx
    mov    [esp + 24], ecx
    mov    [esp + 28], edx

    mov    eax, [esi + xwin.class]
    mov    ebx, [esi + xwin.visual]
    mov    ecx, [esi + xwin.valuemask]
    lea    edx, [gui_t.xswa_t]
    mov    [esp + 32], eax
    mov    [esp + 36], ebx
    mov    [esp + 40], ecx
    mov    [esp + 44], edx

    call   XCreateWindow
    add    esp, 48

    mov    [esi + xwin.window], eax


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Overwrite WM_PROTOCOLS property with our specified atom
;
;   Status XSetWMProtocols(Display *display,
;                          Window   w,
;                          Atom    *protocols,
;                          int      count)
;
;   If the function failed to intern the WM_PROTOCOLS, the return
;   status will be zero.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    sub    esp, 16
    mov    eax, [gui_t.xserver_t + xserver.pDisplay]
    mov    ebx, [gui_t.xwin_t + xwin.window]
    lea    ecx, [gui_t.xwin_t + xwin.wm_delete_msg]
    mov    edx, 1
    mov    [esp     ], eax
    mov    [esp +  4], ebx
    mov    [esp +  8], ecx
    mov    [esp + 12], edx
    call   XSetWMProtocols
    add    esp, 16


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Map our plain window
;
;   void XMapWindow(Display *display, Window w)
;
;   This function maps the window and all of its subwindows that have
;   map requests.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    sub    esp, 8
    mov    eax, [gui_t.xserver_t + xserver.pDisplay]
    mov    ebx, [gui_t.xwin_t + xwin.window]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   XMapWindow
    add    esp, 8


.mainloop:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Get event
;
;   XNextEvent(Display *display, XEvent *event_return)
;
;   This function copies the first event from the event queue into the
;   specified XEvent structure and then removes it from the queue. If
;   the event queue is empty, XNextEvent flushes the output buffer and
;   blocks until an event is received.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    sub    esp, 8
    mov    eax, [gui_t.xserver_t + xserver.pDisplay]
    lea    ebx, [gui_t.xevent_t]
    mov    [esp    ], eax
    mov    [esp + 4], ebx
    call   XNextEvent
    add    esp, 8


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Exit if the type of event is buttonpress
;
;   Note:
;       0100 = Mouse/Touchpad Button Press
;       0101 = Mouse/Touchpad Button Release
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [gui_t.xevent_t + xevent.data + 0]
    cmp    eax, 0b0100
    je     .exit


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Also exit if button "X" (Close button) is clicked
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, [gui_t.xevent_t + xevent.data + 0]
    cmp    eax, 0b100001
    jne    .is_not_msg_delete


.is_msg_delete:
    mov    eax, [gui_t.xevent_t + xevent.data + 28]
    mov    ebx, [gui_t.xwin_t + xwin.wm_delete_msg]
    cmp    eax, ebx
    je     .exit


.is_not_msg_delete:
    jmp    .mainloop


.exit:


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Disconnect from X Server
;
;   void XCloseDisplay(Display *display)
;
;   This function destroys all windows, resource IDs, and other
;   resources created by the client on this display.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    sub    esp, 4
    mov    eax, [gui_t.xserver_t + xserver.pDisplay]
    mov    [esp], eax
    call   XCloseDisplay
    add    esp, 4


;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Systemcall exit(0)
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
    mov    eax, 0x1
    mov    ebx, 0x0
    int    0x80
