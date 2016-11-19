[section .data]
	msg_cmd db 10,"CMD:",0
	msg_file_err db "File Error!", 10, 0
	instructions db "][,.-+><", 0

[section .bss]
	mem resb 30000

[section .text]
extern printf, fopen, fgetc, putchar, getchar, exit
global main
main:

mov r12, mem

mainloop:
mov edi, msg_cmd
mov eax, 0
call printf

mainloop1:


call getchar
cmp al, 0xff
je lexit
cmp al, 0x0a
je mainloop1

mov rcx, 9

mov rbx, instructions
mov rdi, rbx
repnz scasb

shl rcx, 2
add rcx, labels
mov eax, [ecx]
jmp rax

labels:
dd mainloop1
dd lleft
dd lright
dd linc
dd ldec
dd lprint
dd linput
dd lstart
dd lend

lleft:
dec r12

jmp mainloop

lright:
inc r12

jmp mainloop

linc:
mov al, [r12]
inc al
mov [r12], al

jmp mainloop

ldec:
mov al, [r12]
dec al
mov [r12], al

jmp mainloop

lprint:
mov di, [r12]
call putchar

jmp mainloop

linput:
call getchar
call getchar
mov [r12], al

jmp mainloop

lstart:
mov rdi, '['
call putchar

jmp mainloop

lend:
mov rdi, ']'
call putchar

jmp mainloop

lexit:
mov rdi, 0
call exit
