[section .data]
	instructions db "][,.-+><", 0xff, 0

	msg_r db "r", 0

	msg_file_err db "File Error!", 10, 0
	msg_argc_err db "Usage: bfia [filename]",10,0

[section .bss]
	mem resb 30000
	code resb 30000

[section .text]
extern printf, fopen, fclose, fgetc, getchar, putchar, exit
global main
main:

setup:
	; check the arguments
	cmp rdi, 2
	jne lexit_argc_err

	; open the file
	mov rdi, [rsi + 8]
	mov esi, msg_r
	call fopen
	cmp rax, 0
	je lexit_file_err
	mov rbp, rax

	; setup the memory pointers
	mov r12, mem
	mov r13, code

	; read the file
	mov rbx, r13
read:
	mov rdi, rbp
	call fgetc
	mov [rbx], al
	inc rbx
	cmp al, 0xFF
	jne read
	
	mov rdi, rbp
	call fclose

	dec r13
mainloop:
	inc r13

	mov rcx, 10
	mov al, [r13]
	mov rbx, instructions
	mov rdi, rbx
	repnz scasb

	shl rcx, 2
	add rcx, labels
	mov eax, [ecx]
	jmp rax

labels:
	dd mainloop
	dd lexit
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
	mov [r12], al

	jmp mainloop

lstart:
	xor al, al
	cmp [r12], al
	je lstart0
	push r13
	jmp mainloop
	
	lstart0:
	mov r14, 1
	
	lstart1:
		inc r13
		
		mov al, '['
		cmp [r13], al
		je lstart_left
		mov al, ']'
		cmp [r13], al
		je lstart_right
		jmp lstart1
	
	lstart_left:
		inc r14
		jmp lstart1
	
	lstart_right:
		dec r14
		cmp r14, 0
		jne lstart1
		jmp mainloop

lend:
	xor al, al
	cmp [r12], al
	jne lend1
	pop r14
	jmp mainloop
	
	lend1:
	pop r13
	dec r13
	jmp mainloop

lexit_argc_err:
	mov rdi, msg_argc_err
	jmp lexit_err_msg

lexit_file_err:
	mov rdi, msg_file_err

lexit_err_msg:
	xor eax, eax
	call printf
lexit:
	mov rdi, 0
	call exit
