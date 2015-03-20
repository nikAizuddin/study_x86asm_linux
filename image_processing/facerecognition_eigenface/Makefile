ASSEMBLER = nasm
LINKER    = ld
FORMAT    = elf32
MACHINE   = elf_i386
_START    = facerecognition_eigenface.asm
BIN       = facerecognition_eigenface
OBJ       = build/facerecognition_eigenface.o \
            build/create_socket.o \
            build/XConnect.o

CREATE_SOCKET = \
"../../../lib80386/src/linux/create_socket/src/create_socket.asm"

XCONNECT = \
"../../../lib80386/src/xorg/X11/XConnect/src/XConnect.asm"

.PHONY: all clean
all:
	@${ASSEMBLER} \
		${_START} \
		-o build/facerecognition_eigenface.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${CREATE_SOCKET} \
		-o build/create_socket.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${ASSEMBLER} \
		${XCONNECT} \
		-o build/XConnect.o \
		-f ${FORMAT} \
		-g -Fstabs

	@${LINKER} \
		${OBJ} \
		-o ${BIN} \
		-m ${MACHINE}

clean:
	@rm \
		${OBJ}
