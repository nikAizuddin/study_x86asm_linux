;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; XEventFunc_KeyRelease.asm
;
; This header file contains function XEventFunc_KeyRelease().
; The function only executed when the program received KeyRelease
; event.
;
; Function XEventFunc_KeyRelease( void ) : void
;
;=====================================================================

section .text


XEventFunc_KeyRelease:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Fill the XEvent_KeyRelease structure
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; READ( socketX, @XEvent_KeyRelease, 31 )
    mov    eax, _SYSCALL_READ_
    mov    ebx, [socketX]
    lea    ecx, [XEvent_KeyRelease]
    mov    edx, 31
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Notify user that the program received KeyRelease event
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

; WRITE( stdout, @evtmsg_KeyRelease, evtmsg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    lea    ecx, [evtmsg_KeyRelease]
    mov    edx, [evtmsg_len]
    int    0x80


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   Check what key was released
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    xor    eax, eax
    mov    al, [XEvent_KeyRelease.keyCode]

    cmp    eax, _KEY_ENTER_
    jne    KeyRelease_not_Enter
KeyRelease_is_Enter:
    lea    ecx, [msg_KeyRelease_Enter]
    jmp    KeyRelease_display_key
KeyRelease_not_Enter:

    cmp    eax, _KEY_SPACE_
    jne    KeyRelease_not_Space
KeyRelease_is_Space:
    lea    ecx, [msg_KeyRelease_Space]
    jmp    KeyRelease_display_key
KeyRelease_not_Space:

    cmp    eax, _KEY_LSHIFT_
    jne    KeyRelease_not_LShift
KeyRelease_is_LShift:
    lea    ecx, [msg_KeyRelease_LShift]
    jmp    KeyRelease_display_key
KeyRelease_not_LShift:

    cmp    eax, _KEY_RSHIFT_
    jne    KeyRelease_not_RShift
KeyRelease_is_RShift:
    lea    ecx, [msg_KeyRelease_RShift]
    jmp    KeyRelease_display_key
KeyRelease_not_RShift:

    cmp    eax, _KEY_LCTRL_
    jne    KeyRelease_not_LCtrl
KeyRelease_is_LCtrl:
    lea    ecx, [msg_KeyRelease_LCtrl]
    jmp    KeyRelease_display_key
KeyRelease_not_LCtrl:

    cmp    eax, _KEY_RCTRL_
    jne    KeyRelease_not_RCtrl
KeyRelease_is_RCtrl:
    lea    ecx, [msg_KeyRelease_RCtrl]
    jmp    KeyRelease_display_key
KeyRelease_not_RCtrl:

    cmp    eax, _KEY_LALT_
    jne    KeyRelease_not_LAlt
KeyRelease_is_LAlt:
    lea    ecx, [msg_KeyRelease_LAlt]
    jmp    KeyRelease_display_key
KeyRelease_not_LAlt:

    cmp    eax, _KEY_RALT_
    jne    KeyRelease_not_RAlt
KeyRelease_is_RAlt:
    lea    ecx, [msg_KeyRelease_RAlt]
    jmp    KeyRelease_display_key
KeyRelease_not_RAlt:


; *** Key 0 -> 9 ***

    cmp    eax, _KEY_1_
    jne    KeyRelease_not_1
KeyRelease_is_1:
    lea    ecx, [msg_KeyRelease_1]
    jmp    KeyRelease_display_key
KeyRelease_not_1:

    cmp    eax, _KEY_2_
    jne    KeyRelease_not_2
KeyRelease_is_2:
    lea    ecx, [msg_KeyRelease_2]
    jmp    KeyRelease_display_key
KeyRelease_not_2:

    cmp    eax, _KEY_3_
    jne    KeyRelease_not_3
KeyRelease_is_3:
    lea    ecx, [msg_KeyRelease_3]
    jmp    KeyRelease_display_key
KeyRelease_not_3:

    cmp    eax, _KEY_4_
    jne    KeyRelease_not_4
KeyRelease_is_4:
    lea    ecx, [msg_KeyRelease_4]
    jmp    KeyRelease_display_key
KeyRelease_not_4:

    cmp    eax, _KEY_5_
    jne    KeyRelease_not_5
KeyRelease_is_5:
    lea    ecx, [msg_KeyRelease_5]
    jmp    KeyRelease_display_key
KeyRelease_not_5:

    cmp    eax, _KEY_6_
    jne    KeyRelease_not_6
KeyRelease_is_6:
    lea    ecx, [msg_KeyRelease_6]
    jmp    KeyRelease_display_key
KeyRelease_not_6:

    cmp    eax, _KEY_7_
    jne    KeyRelease_not_7
KeyRelease_is_7:
    lea    ecx, [msg_KeyRelease_7]
    jmp    KeyRelease_display_key
KeyRelease_not_7:

    cmp    eax, _KEY_8_
    jne    KeyRelease_not_8
KeyRelease_is_8:
    lea    ecx, [msg_KeyRelease_8]
    jmp    KeyRelease_display_key
KeyRelease_not_8:

    cmp    eax, _KEY_9_
    jne    KeyRelease_not_9
KeyRelease_is_9:
    lea    ecx, [msg_KeyRelease_9]
    jmp    KeyRelease_display_key
KeyRelease_not_9:

    cmp    eax, _KEY_0_
    jne    KeyRelease_not_0
KeyRelease_is_0:
    lea    ecx, [msg_KeyRelease_0]
    jmp    KeyRelease_display_key
KeyRelease_not_0:


; *** Key Q -> P ***

    cmp    eax, _KEY_Q_
    jne    KeyRelease_not_Q
KeyRelease_is_Q:
    lea    ecx, [msg_KeyRelease_Q]
    jmp    KeyRelease_display_key
KeyRelease_not_Q:

    cmp    eax, _KEY_W_
    jne    KeyRelease_not_W
KeyRelease_is_W:
    lea    ecx, [msg_KeyRelease_W]
    jmp    KeyRelease_display_key
KeyRelease_not_W:

    cmp    eax, _KEY_E_
    jne    KeyRelease_not_E
KeyRelease_is_E:
    lea    ecx, [msg_KeyRelease_E]
    jmp    KeyRelease_display_key
KeyRelease_not_E:

    cmp    eax, _KEY_R_
    jne    KeyRelease_not_R
KeyRelease_is_R:
    lea    ecx, [msg_KeyRelease_R]
    jmp    KeyRelease_display_key
KeyRelease_not_R:

    cmp    eax, _KEY_T_
    jne    KeyRelease_not_T
KeyRelease_is_T:
    lea    ecx, [msg_KeyRelease_T]
    jmp    KeyRelease_display_key
KeyRelease_not_T:

    cmp    eax, _KEY_Y_
    jne    KeyRelease_not_Y
KeyRelease_is_Y:
    lea    ecx, [msg_KeyRelease_Y]
    jmp    KeyRelease_display_key
KeyRelease_not_Y:

    cmp    eax, _KEY_U_
    jne    KeyRelease_not_U
KeyRelease_is_U:
    lea    ecx, [msg_KeyRelease_U]
    jmp    KeyRelease_display_key
KeyRelease_not_U:

    cmp    eax, _KEY_I_
    jne    KeyRelease_not_I
KeyRelease_is_I:
    lea    ecx, [msg_KeyRelease_I]
    jmp    KeyRelease_display_key
KeyRelease_not_I:

    cmp    eax, _KEY_O_
    jne    KeyRelease_not_O
KeyRelease_is_O:
    lea    ecx, [msg_KeyRelease_O]
    jmp    KeyRelease_display_key
KeyRelease_not_O:

    cmp    eax, _KEY_P_
    jne    KeyRelease_not_P
KeyRelease_is_P:
    lea    ecx, [msg_KeyRelease_P]
    jmp    KeyRelease_display_key
KeyRelease_not_P:


; *** Key A -> L ***

    cmp    eax, _KEY_A_
    jne    KeyRelease_not_A
KeyRelease_is_A:
    lea    ecx, [msg_KeyRelease_A]
    jmp    KeyRelease_display_key
KeyRelease_not_A:

    cmp    eax, _KEY_S_
    jne    KeyRelease_not_S
KeyRelease_is_S:
    lea    ecx, [msg_KeyRelease_S]
    jmp    KeyRelease_display_key
KeyRelease_not_S:

    cmp    eax, _KEY_D_
    jne    KeyRelease_not_D
KeyRelease_is_D:
    lea    ecx, [msg_KeyRelease_D]
    jmp    KeyRelease_display_key
KeyRelease_not_D:

    cmp    eax, _KEY_F_
    jne    KeyRelease_not_F
KeyRelease_is_F:
    lea    ecx, [msg_KeyRelease_F]
    jmp    KeyRelease_display_key
KeyRelease_not_F:

    cmp    eax, _KEY_G_
    jne    KeyRelease_not_G
KeyRelease_is_G:
    lea    ecx, [msg_KeyRelease_G]
    jmp    KeyRelease_display_key
KeyRelease_not_G:

    cmp    eax, _KEY_H_
    jne    KeyRelease_not_H
KeyRelease_is_H:
    lea    ecx, [msg_KeyRelease_H]
    jmp    KeyRelease_display_key
KeyRelease_not_H:

    cmp    eax, _KEY_J_
    jne    KeyRelease_not_J
KeyRelease_is_J:
    lea    ecx, [msg_KeyRelease_J]
    jmp    KeyRelease_display_key
KeyRelease_not_J:

    cmp    eax, _KEY_K_
    jne    KeyRelease_not_K
KeyRelease_is_K:
    lea    ecx, [msg_KeyRelease_K]
    jmp    KeyRelease_display_key
KeyRelease_not_K:

    cmp    eax, _KEY_L_
    jne    KeyRelease_not_L
KeyRelease_is_L:
    lea    ecx, [msg_KeyRelease_L]
    jmp    KeyRelease_display_key
KeyRelease_not_L:


; *** Key Z -> M ***

    cmp    eax, _KEY_Z_
    jne    KeyRelease_not_Z
KeyRelease_is_Z:
    lea    ecx, [msg_KeyRelease_Z]
    jmp    KeyRelease_display_key
KeyRelease_not_Z:

    cmp    eax, _KEY_X_
    jne    KeyRelease_not_X
KeyRelease_is_X:
    lea    ecx, [msg_KeyRelease_X]
    jmp    KeyRelease_display_key
KeyRelease_not_X:

    cmp    eax, _KEY_C_
    jne    KeyRelease_not_C
KeyRelease_is_C:
    lea    ecx, [msg_KeyRelease_C]
    jmp    KeyRelease_display_key
KeyRelease_not_C:

    cmp    eax, _KEY_V_
    jne    KeyRelease_not_V
KeyRelease_is_V:
    lea    ecx, [msg_KeyRelease_V]
    jmp    KeyRelease_display_key
KeyRelease_not_V:

    cmp    eax, _KEY_B_
    jne    KeyRelease_not_B
KeyRelease_is_B:
    lea    ecx, [msg_KeyRelease_B]
    jmp    KeyRelease_display_key
KeyRelease_not_B:

    cmp    eax, _KEY_N_
    jne    KeyRelease_not_N
KeyRelease_is_N:
    lea    ecx, [msg_KeyRelease_N]
    jmp    KeyRelease_display_key
KeyRelease_not_N:

    cmp    eax, _KEY_M_
    jne    KeyRelease_not_M
KeyRelease_is_M:
    lea    ecx, [msg_KeyRelease_M]
    jmp    KeyRelease_display_key
KeyRelease_not_M:


; *** Unknown keys ***

    lea    ecx, [msg_KeyRelease_Unknown]


KeyRelease_display_key:
; WRITE( stdout, @ECX, msg_len )
    mov    eax, _SYSCALL_WRITE_
    mov    ebx, _STDOUT_
    mov    edx, [msg_len]
    int    0x80
    jmp    mainloop
