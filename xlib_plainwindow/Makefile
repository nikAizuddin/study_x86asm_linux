ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = xlib_plainwindow.asm
BIN       = exe
OBJ       = xlib_plainwindow.o
DLL       = /lib/ld-linux.so.2 \
            /lib/libX11.so.6

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o xlib_plainwindow.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE} \
		-dynamic-linker ${DLL}

clean:
	@rm \
		${OBJ} \
		${BIN}

