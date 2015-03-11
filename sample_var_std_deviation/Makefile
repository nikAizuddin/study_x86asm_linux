ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = src/sample_var_std_deviation.asm
BIN       = bin/exe
OBJ       = build/sample_var_std_deviation.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o build/sample_var_std_deviation.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
