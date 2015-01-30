ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = write.asm
BIN       = exe
OBJ       = write.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o write.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
