ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = example_powReal.asm
BIN       = exe
OBJ       = example_powReal.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o example_powReal.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
