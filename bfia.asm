[section .data]
	r db "r",0
	ac db "a.bf",0
	openerr db "Open Error",10,0
	mallocerr db "Malloc Error",10,0
	output db "The char is %c",10,0

[section .bss]
	mem resb 30000
	code resb 30000

[section .text]
extern printf, fopen, fgetc, putchar, getchar, malloc, exit
global main
main:
;Allocate the memory,prepare the registers
	mov rbp, mem	;use rbp as the memory of the bf machine
	mov r12, code	;use r12 as the pointer of the bf code
	xor r13, r13	;use r13 as the count of the loops

;open the source file
	xor rax, rax	;set rax to 0
	mov edi, ac
	mov esi, r
	call fopen
	cmp rax, 0		;0 means error here
	jz open_error
	mov rbx, rax
	
;get chars from the file
getc:
	mov rdi, rbx
	xor rax, rax
	call fgetc
	mov byte [r12], al
	inc r12
	cmp al, 0xFF	;0XFF is -1 of a char,which means EOF
	jne	getc
	mov r12, code	;reset r12 to the start point of the code
	dec r12			;make r12 one less than the start point for "inc r12"

;find the meaning of the char
bf:
	inc r12
	mov al, byte [r12]
	cmp al, 0xFF	;0XFF is -1 of a char,which means EOF
	je q
	
	cmp al, '+'
	je increase
	cmp al, '-'
	je decrease
	cmp al, ','
	je input
	cmp al, '.'
	je display
	cmp al, '<'
	je left
	cmp al, '>'
	je right
	cmp al, '['
	je loop
	cmp al, ']'
	je endloop
	jmp bf

;print open error
open_error:
	mov rdi, openerr
	jmp err

malloc_error:
	mov rdi, mallocerr
	jmp err

err:
	xor rax, rax
	call printf
	mov rdi, 1		;set rdi to 1,which means exit unexpected
	call qerror
	
q:
	xor rdi, rdi	;set rdi to 0,which means exit normally

qerror:
	call exit


;Instructions of Brainfuck
increase:
	inc byte [rbp]
	jmp bf

decrease:
	dec byte [rbp]
	jmp bf

left:
	dec rbp
	jmp bf

right:
	inc rbp
	jmp bf

input:
	call getchar
	mov byte [rbp], al
	jmp bf

display:
	mov al, byte [rbp]
	mov rdi, rax
	call putchar
	jmp bf
loop:
	inc r13
	mov al, byte [rbp]
	cmp al, 0
	jz findend		;if the byte of the memory is 0,find the end of the loop
	push r12
	jmp bf

endloop:
	dec r13
	mov al, byte [rbp]
	cmp al, 0
	jne endloop1
	pop rax
	jmp bf
endloop1:
	pop r12
	jmp loop

;Some other functions
findend:
	push r13
findend1:
	inc r12
	mov al, byte [r12]
	cmp al, '['
	jne findend2
	inc r13
findend2:
	cmp al, ']'
	jne findend1
	pop rax
	cmp rax, r13	;compare the level of the loop,if it's equal to the origin loop,jump to bf
	jne findend3	;jumps must follow the comparations
	dec r13			;no matter what the ']' means,r13 should be decreased after the comparation
	jmp bf

findend3:
	dec r13			;no matter what the ']' means,r13 should be decreased after the comparation
	push rax
	jmp findend1
