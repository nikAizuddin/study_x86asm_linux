ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = mean_faces.asm
BIN       = mean_faces
OBJ       = mean_faces.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o mean_faces.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
