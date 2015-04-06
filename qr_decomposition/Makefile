ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = qr_decomposition.asm
BIN       = exe
OBJ       = qr_decomposition.o

EUCLIDEAN_NORM = \
  "../../lib80386/src/math/euclidean_norm/src/euclidean_norm.asm"

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o qr_decomposition.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${EUCLIDEAN_NORM} \
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
