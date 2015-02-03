ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = x_connect_disconnect.asm
BIN       = exe
OBJ       = x_connect_disconnect.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o x_connect_disconnect.o \
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
