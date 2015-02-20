ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = example_PUNPCKLBW.asm
BIN       = exe
OBJ       = example_PUNPCKLBW.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o example_PUNPCKLBW.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
