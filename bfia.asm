[section .data]
	r db "r",0
	ac db "a.bf",0
	openerr db "Open Error",10,0
	mallocerr db "Malloc Error",10,0
	output db "The char is %c",10,0

[section .bss]
	mem resb 30000

[section .text]
extern printf, fopen, fgetc, putchar, getchar, malloc, exit
global main
main:
;Allocate the memory
	;Allocate with malloc
	;mov rdi, 30000
	;call malloc
	;cmp rax, 0
	;jz malloc_error
	;mov rbp, rax
	
	;use .bss memory
	mov rbp, mem

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
	
;find the meaning of the char
	cmp al, 0xFF	;0XFF is -1 of a char
	je q
	
	cmp rax, '+'
	je increase
	cmp rax, '-'
	je decrease
	cmp rax, ','
	je input
	cmp rax, '.'
	je display
	cmp rax, '<'
	je left
	cmp rax, '>'
	je right
	cmp rax, '['
	je loop
	cmp rax, ']'
	je endloop
	jmp getc

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
	jmp getc

decrease:
	dec byte [rbp]
	jmp getc

left:
	inc rbp
	jmp getc

right:
	dec rbp
	jmp getc

input:
	call getchar
	mov byte [rbp], al
	jmp getc

display:
	mov al, byte [rbp]
	mov rdi, rax
	call putchar
	jmp getc
loop:
	
endloop:
	
