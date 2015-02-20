ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = example_EMMS.asm
BIN       = exe
OBJ       = example_EMMS.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o example_EMMS.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
