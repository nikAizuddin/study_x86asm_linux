ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = allocate_heap_memory.asm
BIN       = exe
OBJ       = allocate_heap_memory.o

.PHONY: all clean

all:
	@${ASSEMBLER} \
		${_START} \
		-o allocate_heap_memory.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
