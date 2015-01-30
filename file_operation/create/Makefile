ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = create.asm
BIN       = exe
OBJ       = create.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o create.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
