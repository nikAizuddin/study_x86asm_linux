ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = src/matrix_determinant.asm
BIN       = bin/exe
OBJ       = build/matrix_determinant.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o build/matrix_determinant.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
