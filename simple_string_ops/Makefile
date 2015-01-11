ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = simple_string_ops.asm
BIN       = exe
OBJ       = simple_string_ops.o

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o simple_string_ops.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
