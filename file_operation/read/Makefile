ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = read.asm
BIN       = exe
OBJ       = read.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o read.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
