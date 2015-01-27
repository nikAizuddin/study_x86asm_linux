ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = simple_string_ops2.asm
BIN       = exe
OBJ       = simple_string_ops2.o

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o simple_string_ops2.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
