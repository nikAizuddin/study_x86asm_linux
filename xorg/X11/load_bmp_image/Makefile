ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = load_bmp_image.asm
BIN       = load_bmp_image
OBJ       = load_bmp_image.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o load_bmp_image.o \
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
