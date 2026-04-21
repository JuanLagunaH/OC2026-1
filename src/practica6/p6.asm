%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
    mov edx,ncad
    call puts

    mov bx,word[len]
    mov edx,cad
    call capturar

    mov al, 0xa
    call putchar
    call putchar

    ;MINUSCULAS
    mov edx, msg_minus
    call puts

    mov edx, cad
    call minusculas 

    mov edx, cad
    call puts

    mov al, 0xa
    call putchar
    call putchar

    ;MAYUSCULAS 
    mov edx, msg_mayus
    call puts

    mov edx, cad
    call minusculas 

    mov edx, cad
    call puts

    mov al, 0xa
    call putchar
    call putchar


	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    capturar:
        push edx
        push cx
        mov cx,bx
        dec cx
    .ciclo: 
        call getch
        cmp al,0x7f
        jne .guardar
        call borrar
        jmp .ciclo
        .guardar:
        call putchar
        mov [edx],al
        cmp al,0xa
        je .salir
        inc edx
        loop .ciclo

        .salir:
        mov byte[edx],0
        pop cx
        pop edx
        ret

    borrar:
        push ax 
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop ax
        ret 

    mayusculas:
        push edx
        push ax

    .ciclomayus:
        mov al, [edx]
        cmp al, 0
        je .salirmayus
        cmp al, 'a'
        jl .siguientemayus
        cmp al, 'z'
        jg .siguientemayus
        sub al, 32
        mov [edx], al
    .siguientemayus:
        inc edx
        jmp .ciclomayus

    .salirmayus:
        pop eax
        pop edx
        ret

    minusculas:
        push edx
        push ax

    .ciclominus:
        mov al, [edx]
        cmp al, 0
        je .salirminus
        cmp al, 'A'
        jl .siguienteminus
        cmp al, 'Z'
        jg .siguienteminus
        add al, 32
        mov [edx], al
    .siguienteminus:
        inc edx
        jmp .ciclominus

    .salirminus:
        pop eax
        pop edx
        ret

section	.data
    ncad db 0xa,'Ingrese una Cadena: ',0
    nlin db 0xa
    msg_minus   db 'Minusculas: ', 0
    msg_mayus   db 'Mayusculas: ', 0
    len db 64
    cad	times 64 db 0