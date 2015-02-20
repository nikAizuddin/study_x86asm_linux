ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = example_DataTransfer.asm
BIN       = exe
OBJ       = example_DataTransfer.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o example_DataTransfer.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
