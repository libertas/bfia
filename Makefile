ASM=nasm

all:bfia bcia

bfia:bfia.asm
	$(ASM) bfia.asm -o bfia.o -f elf64 && cc bfia.o -o bfia

bcia:bcia.asm
	$(ASM) bcia.asm -o bcia.o -f elf64 && cc bcia.o -o bcia

.PHONY: install clean

install:all
	cp bfia /usr/local/bin/bfia
	cp bcia /usr/local/bin/bcia

uninstall:
	rm /usr/local/bin/bfia
	rm /usr/local/bin/bcia

clean:
	rm bfia.o bfia
	rm bcia.o bcia
