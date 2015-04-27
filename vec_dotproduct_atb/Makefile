ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = vec_dotproduct_atb.asm
BIN       = exe
OBJ       = vec_dotproduct_atb.o

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o vec_dotproduct_atb.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
