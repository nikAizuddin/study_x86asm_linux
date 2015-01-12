ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = simple_array.asm
BIN       = exe
OBJ       = simple_array.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o simple_array.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
