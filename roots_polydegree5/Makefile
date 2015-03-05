ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = src/roots_polydegree5.asm
BIN       = bin/exe
OBJ       = build/roots_polydegree5.o \
            build/pow.o

POW       = src/subroutines/pow.asm

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o build/roots_polydegree5.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${POW} \
		-o build/pow.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
