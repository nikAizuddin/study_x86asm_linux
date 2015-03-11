ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = src/calc_mean.asm
BIN       = bin/exe
OBJ       = build/calc_mean.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o build/calc_mean.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
