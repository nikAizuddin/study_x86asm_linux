ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = facerecognition_eigenface.asm
BIN       = facerecognition_eigenface
OBJ       = facerecognition_eigenface.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o facerecognition_eigenface.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
