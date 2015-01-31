ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = simple_networking.asm
BIN       = exe
OBJ       = simple_networking.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o simple_networking.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
