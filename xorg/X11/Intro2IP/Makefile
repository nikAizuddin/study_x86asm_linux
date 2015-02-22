ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = Intro2IP.asm
BIN       = Intro2IP
OBJ       = Intro2IP.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o Intro2IP.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
