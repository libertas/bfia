ASM=nasm

all:bfia

bfia:bfia.asm
	$(ASM) bfia.asm -o bfia.o -f elf64 && cc bfia.o -o bfia

.PHONY: install clean

install:all
	cp bfia /usr/local/bin/bfia

uninstall:
	rm /usr/local/bin/bfia

clean:
	rm bfia.o bfia
