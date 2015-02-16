ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = plain_window.asm
BIN       = plain_window
OBJ       = plain_window.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o plain_window.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
