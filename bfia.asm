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
;Allocate the memory
	mov rbp, mem
	mov r12, code

;open the source file
	xor rax, rax
	mov edi, ac
	mov esi, r
	call fopen
	cmp rax, 0
	jz open_error
	mov rbx, rax
	
;get chars from the file
getc:
	mov rdi, rbx
	xor rax, rax
	call fgetc
	mov byte [r12], al
	inc r12
	cmp al, 0xFF	;0XFF is -1 of a char
	jne	getc
	mov r12, code	;reset r12 to the start point of the code
	dec r12			;make r12 one less than the start point for "inc r12"

;find the meaning of the char
bf:
	inc r12
	mov al, byte [r12]
	cmp al, 0xFF	;0XFF is -1 of a char
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
	mov rdi, 1
	call qerror
	
q:
	xor rdi, rdi

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
	
	jmp bf
endloop:
	
	jmp bf
