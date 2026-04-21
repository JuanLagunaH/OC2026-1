%include "../../lib/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:     


    mov eax,24  
    mov edx,cad
    mov bl,byte[lencad]
    call itoa
    call puts

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

    mov edx,ncad
    call puts
    mov eax,arr
    mov edx,0
    mov dl,byte[len]
    call impArreglo
    mov al,10
    call putchar

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa


    impArreglo:
        push ecx
        push esi
        mov ecx,0
        mov esi,0
        mov cl,dl   
       .cicloImpArr:
        push eax
        push edx
        ;PARAMETRO DE ITOA
        mov edx,eax
        mov eax,dword[edx+esi*4]    
        mov edx,cad
        mov bl,byte[lencad]
        call itoa

        mov edx,cad
        call puts
        mov al,' '
        call putchar

        inc esi
        pop edx
        pop eax
        loop .cicloImpArr

        pop esi
        pop ecx
        ret 
    
    itoa:
        ;eax NUMERO ENTERO
        ;edx CADENA
        ;bl Longitud de la cadena        
        push dword[divBase]
        pop dword[divi]

        push esi
        mov esi,0
        mov dword[cociente],0
        mov dword[residuo],0
        mov dword[numero],eax        
        cmp eax,0
        jge .while 
        mov byte[edx+esi],'-'
        inc esi
       
        .while:
        push eax
        push edx
        mov edx,0
        idiv dword[divi]
        cmp eax,0
        jne .salir
        mov edx,0
        mov eax,dword[divi]
        idiv dword[base]
        mov dword[divi],eax                
        pop edx
        pop eax
        jmp .while
        
        .salir:
        pop edx
        pop eax

        .do:
        push edx
        mov edx,0
        mov eax,dword[numero]
        idiv dword[divi]
        mov dword[cociente],eax
        mov dword[residuo],edx
        pop edx

        add dword[cociente],'0'
        push ebx
        mov bl,byte[cociente]
        mov byte[edx+esi],bl
        pop ebx
        inc esi
        push dword[residuo]
        pop dword[numero]
        push edx
        mov edx,0
        mov eax,dword[divi]
        idiv dword[base]
        mov dword[divi],eax  
        pop edx
        cmp dword[numero],0
        jg .do        
        mov byte[edx+esi],0

        pop esi
        ret

section	.data
    ncad db 0xa,'Arreglo: ',0
    nlin db 0xa
    lencad db 64
    cad	times 64 db 0
    len db 5
    arr	dd 24,4,3,2,52

    
    numero dd 0
    cociente dd 0
    residuo dd 0
    base dd 10
    divBase dd 1000000000
    divi dd 0
    