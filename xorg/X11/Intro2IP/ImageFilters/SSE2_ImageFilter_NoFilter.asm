;        1         2         3         4         5         6         7
;234567890123456789012345678901234567890123456789012345678901234567890
;=====================================================================
;
; SSE2_ImageFilter_NoFilter.asm
;
; Restore imgCurrent to original image.
;
; This source file contains function SSE2_ImageFilter_NoFilter().
; The function only executed when key "Q" is pressed.
;
; Function SSE2_ImageFilter_NoFilter( void ) : void
;
;=====================================================================

section .text


SSE2_ImageFilter_NoFilter:


;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;   This loop_NoFilter_restore() will fill the imgCurrent pixel
;   and XImage pixel with imgOriginal pixel.
;
;   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    lea    esi, [imgOriginal.pixel] ;source pixel
    lea    edi, [imgCurrent.pixel]  ;destination1 pixel
    lea    ebx, [XImage.pixel]      ;destination2 pixel

    mov    ecx, (_IMG_WIDTH_*_IMG_HEIGHT_)

loop_NoFilter_restore:

    movdqa xmm0, [esi]
    movdqa xmm1, xmm0

    cvtps2dq xmm1, xmm1 ;Convert single-precision to dword
    packssdw xmm1, xmm7 ;Convert dword to word
    packuswb xmm1, xmm7 ;Convert word to byte

    movdqa  [edi], xmm0
    movd    [ebx], xmm1

    add    esi, _COLUMNSIZE_32_
    add    edi, _COLUMNSIZE_32_
    add    ebx, _COLUMNSIZE_8_

    sub    ecx, 1
    jnz    loop_NoFilter_restore

endloop_NoFilter_restore:

    jmp    upload_appliedFilter ;apply_ImageFilter.asm
