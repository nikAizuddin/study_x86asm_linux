ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = bubble_sort.asm
BIN       = exe
OBJ       = bubble_sort.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o bubble_sort.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
