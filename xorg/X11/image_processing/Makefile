ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = image_processing.asm
BIN       = image_processing
OBJ       = image_processing.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o image_processing.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ} \
		${BIN}
