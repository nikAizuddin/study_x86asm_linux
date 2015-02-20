;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_KeyPress.asm
;
; This source file contains function XEventFunc_KeyPress().
; The function only executed when the program received KeyPress
; event.
;
; Function XEventFunc_KeyPress( void ) : void
;
;=====================================================================

section .text


XEventFunc_KeyPress:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received KeyPress event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_KeyPress, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_KeyPress]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_KeyPress structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_KeyPress, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_KeyPress]
    mov    edx, 31
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check what key was pressed
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    xor    eax, eax
    mov    al, [XEvent_KeyPress.keyCode]

    cmp    eax, _KEY_ENTER_
    jne    KeyPress_not_Enter
KeyPress_is_Enter:
    lea    ecx, [msg_KeyPress_Enter]
    jmp    KeyPress_display_key
KeyPress_not_Enter:

    cmp    eax, _KEY_SPACE_
    jne    KeyPress_not_Space
KeyPress_is_Space:
    lea    ecx, [msg_KeyPress_Space]
    jmp    KeyPress_display_key
KeyPress_not_Space:

    cmp    eax, _KEY_LSHIFT_
    jne    KeyPress_not_LShift
KeyPress_is_LShift:
    lea    ecx, [msg_KeyPress_LShift]
    jmp    KeyPress_display_key
KeyPress_not_LShift:

    cmp    eax, _KEY_RSHIFT_
    jne    KeyPress_not_RShift
KeyPress_is_RShift:
    lea    ecx, [msg_KeyPress_RShift]
    jmp    KeyPress_display_key
KeyPress_not_RShift:

    cmp    eax, _KEY_LCTRL_
    jne    KeyPress_not_LCtrl
KeyPress_is_LCtrl:
    lea    ecx, [msg_KeyPress_LCtrl]
    jmp    KeyPress_display_key
KeyPress_not_LCtrl:

    cmp    eax, _KEY_RCTRL_
    jne    KeyPress_not_RCtrl
KeyPress_is_RCtrl:
    lea    ecx, [msg_KeyPress_RCtrl]
    jmp    KeyPress_display_key
KeyPress_not_RCtrl:

    cmp    eax, _KEY_LALT_
    jne    KeyPress_not_LAlt
KeyPress_is_LAlt:
    lea    ecx, [msg_KeyPress_LAlt]
    jmp    KeyPress_display_key
KeyPress_not_LAlt:

    cmp    eax, _KEY_RALT_
    jne    KeyPress_not_RAlt
KeyPress_is_RAlt:
    lea    ecx, [msg_KeyPress_RAlt]
    jmp    KeyPress_display_key
KeyPress_not_RAlt:


; *** Key 0 -> 9 ***

    cmp    eax, _KEY_1_
    jne    KeyPress_not_1
KeyPress_is_1:
    lea    ecx, [msg_KeyPress_1]
    jmp    KeyPress_display_key
KeyPress_not_1:

    cmp    eax, _KEY_2_
    jne    KeyPress_not_2
KeyPress_is_2:
    lea    ecx, [msg_KeyPress_2]
    jmp    KeyPress_display_key
KeyPress_not_2:

    cmp    eax, _KEY_3_
    jne    KeyPress_not_3
KeyPress_is_3:
    lea    ecx, [msg_KeyPress_3]
    jmp    KeyPress_display_key
KeyPress_not_3:

    cmp    eax, _KEY_4_
    jne    KeyPress_not_4
KeyPress_is_4:
    lea    ecx, [msg_KeyPress_4]
    jmp    KeyPress_display_key
KeyPress_not_4:

    cmp    eax, _KEY_5_
    jne    KeyPress_not_5
KeyPress_is_5:
    lea    ecx, [msg_KeyPress_5]
    jmp    KeyPress_display_key
KeyPress_not_5:

    cmp    eax, _KEY_6_
    jne    KeyPress_not_6
KeyPress_is_6:
    lea    ecx, [msg_KeyPress_6]
    jmp    KeyPress_display_key
KeyPress_not_6:

    cmp    eax, _KEY_7_
    jne    KeyPress_not_7
KeyPress_is_7:
    lea    ecx, [msg_KeyPress_7]
    jmp    KeyPress_display_key
KeyPress_not_7:

    cmp    eax, _KEY_8_
    jne    KeyPress_not_8
KeyPress_is_8:
    lea    ecx, [msg_KeyPress_8]
    jmp    KeyPress_display_key
KeyPress_not_8:

    cmp    eax, _KEY_9_
    jne    KeyPress_not_9
KeyPress_is_9:
    lea    ecx, [msg_KeyPress_9]
    jmp    KeyPress_display_key
KeyPress_not_9:

    cmp    eax, _KEY_0_
    jne    KeyPress_not_0
KeyPress_is_0:
    lea    ecx, [msg_KeyPress_0]
    jmp    KeyPress_display_key
KeyPress_not_0:


; *** Key Q -> P ***

    cmp    eax, _KEY_Q_
    jne    KeyPress_not_Q
KeyPress_is_Q:
    lea    ecx, [msg_KeyPress_Q]
    jmp    SSE2_ImageFilter_NoFilter
KeyPress_not_Q:

    cmp    eax, _KEY_W_
    jne    KeyPress_not_W
KeyPress_is_W:
    lea    ecx, [msg_KeyPress_W]
    jmp    SSE2_ImageFilter_Mean
KeyPress_not_W:

    cmp    eax, _KEY_E_
    jne    KeyPress_not_E
KeyPress_is_E:
    lea    ecx, [msg_KeyPress_E]
    jmp    KeyPress_display_key
KeyPress_not_E:

    cmp    eax, _KEY_R_
    jne    KeyPress_not_R
KeyPress_is_R:
    lea    ecx, [msg_KeyPress_R]
    jmp    KeyPress_display_key
KeyPress_not_R:

    cmp    eax, _KEY_T_
    jne    KeyPress_not_T
KeyPress_is_T:
    lea    ecx, [msg_KeyPress_T]
    jmp    KeyPress_display_key
KeyPress_not_T:

    cmp    eax, _KEY_Y_
    jne    KeyPress_not_Y
KeyPress_is_Y:
    lea    ecx, [msg_KeyPress_Y]
    jmp    KeyPress_display_key
KeyPress_not_Y:

    cmp    eax, _KEY_U_
    jne    KeyPress_not_U
KeyPress_is_U:
    lea    ecx, [msg_KeyPress_U]
    jmp    KeyPress_display_key
KeyPress_not_U:

    cmp    eax, _KEY_I_
    jne    KeyPress_not_I
KeyPress_is_I:
    lea    ecx, [msg_KeyPress_I]
    jmp    KeyPress_display_key
KeyPress_not_I:

    cmp    eax, _KEY_O_
    jne    KeyPress_not_O
KeyPress_is_O:
    lea    ecx, [msg_KeyPress_O]
    jmp    KeyPress_display_key
KeyPress_not_O:

    cmp    eax, _KEY_P_
    jne    KeyPress_not_P
KeyPress_is_P:
    lea    ecx, [msg_KeyPress_P]
    jmp    KeyPress_display_key
KeyPress_not_P:


; *** Key A -> L ***

    cmp    eax, _KEY_A_
    jne    KeyPress_not_A
KeyPress_is_A:
    lea    ecx, [msg_KeyPress_A]
    jmp    KeyPress_display_key
KeyPress_not_A:

    cmp    eax, _KEY_S_
    jne    KeyPress_not_S
KeyPress_is_S:
    lea    ecx, [msg_KeyPress_S]
    jmp    KeyPress_display_key
KeyPress_not_S:

    cmp    eax, _KEY_D_
    jne    KeyPress_not_D
KeyPress_is_D:
    lea    ecx, [msg_KeyPress_D]
    jmp    KeyPress_display_key
KeyPress_not_D:

    cmp    eax, _KEY_F_
    jne    KeyPress_not_F
KeyPress_is_F:
    lea    ecx, [msg_KeyPress_F]
    jmp    KeyPress_display_key
KeyPress_not_F:

    cmp    eax, _KEY_G_
    jne    KeyPress_not_G
KeyPress_is_G:
    lea    ecx, [msg_KeyPress_G]
    jmp    KeyPress_display_key
KeyPress_not_G:

    cmp    eax, _KEY_H_
    jne    KeyPress_not_H
KeyPress_is_H:
    lea    ecx, [msg_KeyPress_H]
    jmp    KeyPress_display_key
KeyPress_not_H:

    cmp    eax, _KEY_J_
    jne    KeyPress_not_J
KeyPress_is_J:
    lea    ecx, [msg_KeyPress_J]
    jmp    KeyPress_display_key
KeyPress_not_J:

    cmp    eax, _KEY_K_
    jne    KeyPress_not_K
KeyPress_is_K:
    lea    ecx, [msg_KeyPress_K]
    jmp    KeyPress_display_key
KeyPress_not_K:

    cmp    eax, _KEY_L_
    jne    KeyPress_not_L
KeyPress_is_L:
    lea    ecx, [msg_KeyPress_L]
    jmp    KeyPress_display_key
KeyPress_not_L:


; *** Key Z -> M ***

    cmp    eax, _KEY_Z_
    jne    KeyPress_not_Z
KeyPress_is_Z:
    lea    ecx, [msg_KeyPress_Z]
    jmp    KeyPress_display_key
KeyPress_not_Z:

    cmp    eax, _KEY_X_
    jne    KeyPress_not_X
KeyPress_is_X:
    lea    ecx, [msg_KeyPress_X]
    jmp    KeyPress_display_key
KeyPress_not_X:

    cmp    eax, _KEY_C_
    jne    KeyPress_not_C
KeyPress_is_C:
    lea    ecx, [msg_KeyPress_C]
    jmp    KeyPress_display_key
KeyPress_not_C:

    cmp    eax, _KEY_V_
    jne    KeyPress_not_V
KeyPress_is_V:
    lea    ecx, [msg_KeyPress_V]
    jmp    KeyPress_display_key
KeyPress_not_V:

    cmp    eax, _KEY_B_
    jne    KeyPress_not_B
KeyPress_is_B:
    lea    ecx, [msg_KeyPress_B]
    jmp    KeyPress_display_key
KeyPress_not_B:

    cmp    eax, _KEY_N_
    jne    KeyPress_not_N
KeyPress_is_N:
    lea    ecx, [msg_KeyPress_N]
    jmp    KeyPress_display_key
KeyPress_not_N:

    cmp    eax, _KEY_M_
    jne    KeyPress_not_M
KeyPress_is_M:
    lea    ecx, [msg_KeyPress_M]
    jmp    KeyPress_display_key
KeyPress_not_M:


; *** Unknown keys ***

    lea    ecx, [msg_KeyPress_Unknown]

KeyPress_display_key:
; WRITE( stdout, @ECX, msg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    mov    edx, [msg_len]
    int    0x80
    jmp    mainloop
