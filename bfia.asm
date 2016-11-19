[section .data]
	msg_file_err db "File Error!", 10, 0
	instructions db "][,.-+><", 0
	
	format db "%lx %lx", 10, 0

[section .bss]
	mem resb 30000

[section .text]
extern printf, fopen, fgetc, putchar, getchar, exit
global main
main:

call getchar
cmp al, 0xff
je lexit

mov rcx, 9

mov rbx, instructions
mov rdi, rbx
repnz scasb

shl rcx, 2
add rcx, labels
mov eax, [ecx]
jmp rax

labels:
dd main
dd lleft
dd lright
dd linc
dd ldec
dd lprint
dd linput
dd lstart
dd lend

lleft:
mov rdi, '<'
call putchar

jmp main

lright:
mov rdi, '>'
call putchar

jmp main

linc:
mov rdi, '+'
call putchar

jmp main

ldec:
mov rdi, '-'
call putchar

jmp main

lprint:
mov rdi, '.'
call putchar

jmp main

linput:
mov rdi, ','
call putchar

jmp main

lstart:
mov rdi, '['
call putchar

jmp main

lend:
mov rdi, ']'
call putchar

jmp main

lexit:
mov rdi, 0
call exit
