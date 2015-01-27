ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = lehmer_random_numbers.asm
BIN       = bin/exe
OBJ       = build/lehmer_random_numbers.o \
            build/string_append.o \
            build/cvt_hex2dec.o \
            build/cvt_dec2string.o \
            build/cvt_int2string.o \
            build/find_int_digits.o \
            build/pow_int.o

STRING_APPEND = \
"./libs/string_append.asm"

CVT_HEX2DEC = \
"./libs/cvt_hex2dec.asm"

CVT_DEC2STRING = \
"./libs/cvt_dec2string.asm"

CVT_INT2STRING = \
"./libs/cvt_int2string.asm"

FIND_INT_DIGITS = \
"./libs/find_int_digits.asm"

POW_INT = \
"./libs/pow_int.asm"

.PHONY: all clean
all:
	@mkdir -p build
	@mkdir -p bin

	@${ASSEMBLER} \
		${_START} \
		-o build/lehmer_random_numbers.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${STRING_APPEND} \
		-o build/string_append.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_HEX2DEC} \
		-o build/cvt_hex2dec.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_DEC2STRING} \
		-o build/cvt_dec2string.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${CVT_INT2STRING} \
		-o build/cvt_int2string.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${FIND_INT_DIGITS} \
		-o build/find_int_digits.o \
		-f ${FORMAT}

	@${ASSEMBLER} \
		${POW_INT} \
		-o build/pow_int.o \
		-f ${FORMAT}

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm -f \
		${OBJ} \
		${BIN}
	@rm -r -f bin build
