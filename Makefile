ASM=nasm

all:bfia bcia

bfia:bfia.asm
	$(ASM) bfia.asm -o bfia.o -f elf64 && cc bfia.o -o bfia

bcia:bcia.asm
	$(ASM) bcia.asm -o bcia.o -f elf64 && cc bcia.o -o bcia

.PHONY: install clean

install:all
	cp bfia /usr/local/bin/bfia

uninstall:
	rm /usr/local/bin/bfia

clean:
	rm bfia.o bfia
