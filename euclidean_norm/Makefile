ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = euclidean_norm.asm
BIN       = euclidean_norm
OBJ       = euclidean_norm.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o euclidean_norm.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
