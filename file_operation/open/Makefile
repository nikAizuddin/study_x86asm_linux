ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = open.asm
BIN       = exe
OBJ       = open.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o open.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
