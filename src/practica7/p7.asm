%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
    mov edx,msg
    call puts

    mov bx,word[len]
    mov edx,cad
    call capturar

    mov al, 0xa
    call putchar
    call putchar

    ;atoi
    mov edx, cad
    call atoi

    ;itoa
    mov edx, resultado
    mov ecx, 64
    call itoa

    mov edx, msg_resultado
    call puts

    mov edx, resultado
    call puts

    mov al, 0xa
    call putchar

    xor ebx, ebx
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

atoi:
    push esi
    push ebx
    push ecx

    mov esi, edx
    xor eax, eax
    xor ebx, ebx
    inc ebx

.atoi_espacios:
    mov cl, [esi]
    cmp cl, ' '
    je .atoi_espacios_inc
    cmp cl, 0x09            ;tab
    jne .atoi_signo
.atoi_espacios_inc:
    inc esi
    jmp .atoi_espacios

.atoi_signo:
    cmp cl, '-'
    jne .atoi_positivo
    mov ebx, -1          ; marcar negativo
    inc esi
    jmp .atoi_digitos
.atoi_positivo:
    cmp cl, '+'
    jne .atoi_digitos
    inc esi             ; saltar '+' y continuar

.atoi_digitos:
    mov cl, [esi]
    cmp cl, '0'
    jl  .atoi_fin     ; carácter < '0' → fin
    cmp cl, '9'
    jg  .atoi_fin    ; carácter > '9' → fin

    imul eax, eax, 10   ; eax = eax * 10
    sub  cl, '0'        ; cl = valor del dígito (0-9)
    movzx ecx, cl       ; ecx = valor extendido (limpia bits altos)
    add  eax, ecx
    inc  esi
    jmp  .atoi_digitos


.atoi_fin:
    imul eax, ebx
    pop ecx
    pop ebx
    pop esi
    ret


itoa:
    push esi
    push edi
    push ebx
    push ecx

    mov esi, edx
    mov edi, edx
    xor ebx, ebx

.itoa_signo:
    test eax, eax
    jge .itoa_cero
    mov byte [edi], '-'
    inc edi
    neg eax

.itoa_cero:
    test eax, eax
    jnz .itoa_extraer
    push dword 0
    inc ebx
    jmp .itoa_escribir

.itoa_extraer:
    test eax, eax
    jz .itoa_escribir
    xor edx, edx
    mov ecx, 10 
    div ecx  
    push edx 
    inc ebx  
    jmp .itoa_extraer 

.itoa_escribir:
    test ebx, ebx 
    jz .itoa_fin 
    pop ecx  
    add cl, '0' 
    mov [edi], cl 
    inc edi 
    dec ebx 
    jmp .itoa_escribir  

.itoa_fin:
    mov byte [edi], 0   ; escribir nulo de fin de cadena
    mov edx, esi        ; restaurar edx = inicio del buffer
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret

section	.data
    msg db 0xa,'Ingrese un numero entero: ',0
    msg_resultado db 0xa,'Numero entero: ',0
    len db 64
    cad	times 64 db 0
    resultado times 64 db 0