ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = mat_copy_column.asm
BIN       = exe
OBJ       = mat_copy_column.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o mat_copy_column.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
