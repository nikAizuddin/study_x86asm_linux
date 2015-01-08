all:
	@nasm boot.asm -o boot.img -fbin
	@sudo mkisofs -pad -b boot.img -R -o boot.iso -no-emul-boot \
	-boot-load-size 4 boot.img

compile:
	@nasm boot.asm -o boot.img -fbin

clean:
	@rm boot.img boot.iso

