ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = connect_to_xserver.asm
BIN       = exe
OBJ       = connect_to_xserver.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o connect_to_xserver.o \
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
