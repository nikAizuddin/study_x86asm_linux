ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = big_integer_add.asm
BIN       = exe
OBJ       = big_integer_add.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o big_integer_add.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
