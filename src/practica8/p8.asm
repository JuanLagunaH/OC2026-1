%include "../../lib/pc_io.inc"

section .text
    global _start

_start:
    ; capturar arreglo
    mov edx, msg_captura
    call puts

    mov eax, arr
    mov dl, [len]
    call capturar_arreglo

    mov al, 0xa
    call putchar

    ; mostrar arreglo
    mov edx, msg_original
    call puts

    mov eax, arr
    mov dl, [len]
    call mostrar_arreglo

    mov al, 0xa
    call putchar

    ;ordenar arreglo
    mov eax, arr
    mov dl, [len]
    call ordenar_arreglo

    ;mostrar arreglo ordenado
    mov edx, msg_ordenado
    call puts

    mov eax, arr
    mov dl, [len]
    call mostrar_arreglo

    mov al, 0xa
    call putchar

    xor ebx, ebx            ; ebx = 0 = codigo de salida exitoso
    mov eax, 1
    int 0x80

capturar_arreglo:
    push eax                ; guardar direccion inicio (valor de retorno)
    push ebx
    push ecx
    push esi

    mov esi, eax            ; esi = puntero que avanza por el arreglo
    movzx ecx, dl           ; ecx = cantidad de elementos (contador del loop)

.cap_arr_ciclo:
    push ecx                ; guardar contador (capturar y atoi lo preservan pero por seguridad)
    push esi                ; guardar posicion actual del arreglo

    mov edx, msg_elemento
    call puts

    movzx ax, byte[lencad]
    mov edx, cad
    call capturar

    mov al, 0xa
    call putchar            ;\n

    mov edx, cad
    call atoi               ; convierte cadena a entero, resultado en eax

    pop esi
    pop ecx

    mov [esi], eax
    add esi, 4

    loop .cap_arr_ciclo

    pop esi
    pop ecx
    pop ebx
    pop eax                 ; restaurar eax = direccion inicio del arreglo
    ret

mostrar_arreglo:
    push edi
    push esi
    push ecx

    mov edi, eax
    movzx ecx, dl
    mov esi, 0

.mostrar_ciclo:
    push ecx
    push esi

    mov eax, [edi + esi*4]
    mov edx, cad
    mov ecx, 64
    call itoa               ; convierte eax a cadena en cad

    mov edx, cad
    call puts               ; imprime el numero

    mov al, ' '
    call putchar

    pop esi
    pop ecx

    inc esi
    loop .mostrar_ciclo

    pop ecx
    pop esi
    pop edi
    ret


ordenar_arreglo:
    push eax 
    push ebp
    push ebx
    push ecx
    push esi
    push edi

    mov ebp, eax 
    movzx ecx, dl 
    xor edi, edi

.ord_externo:
    mov eax, ecx
    dec eax 
    cmp edi, eax
    jge .ordenar_fin

    mov ebx, edi
    mov esi, edi
    inc esi

.ord_interno:
    cmp esi, ecx
    jge .ord_interno_fin

    mov eax, [ebp + esi*4]
    cmp eax, [ebp + ebx*4]
    jge .ord_no_min
    mov ebx, esi

.ord_no_min:
    inc esi
    jmp .ord_interno

.ord_interno_fin:
    cmp ebx, edi
    je  .ord_siguiente_i

    mov eax, [ebp + edi*4]
    mov edx, [ebp + ebx*4]
    mov [ebp + edi*4], edx
    mov [ebp + ebx*4], eax

.ord_siguiente_i:
    inc edi
    jmp .ord_externo

.ordenar_fin:
    pop edi
    pop esi
    pop ecx
    pop ebx
    pop ebp
    pop eax
    ret


capturar:
    push edx
    push ecx
    push ebx
    movzx ecx, ax 
    dec ecx
    mov ebx, edx

.cicloCapturar:
    call getch
    cmp al, 0xa  
    je  .salirCapturar
    cmp al, 0x7f       
    je  .cap_back

    test ecx, ecx 
    jz  .cicloCapturar

    call putchar 
    mov [edx], al
    inc edx
    dec ecx
    jmp .cicloCapturar

.cap_back:
    cmp edx, ebx 
    je  .cicloCapturar
    call borrar
    dec edx
    inc ecx
    jmp .cicloCapturar

.salirCapturar:
    mov byte[edx], 0        ; nulo de fin de cadena
    pop ebx
    pop ecx
    pop edx
    ret


borrar:
    push eax
    mov al, 0x8
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x8
    call putchar
    pop eax
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
    je  .atoi_esp_inc
    cmp cl, 0x09            ; tabulacion
    jne .atoi_signo
.atoi_esp_inc:
    inc esi
    jmp .atoi_espacios

.atoi_signo:
    cmp cl, '-'
    jne .atoi_positivo
    mov ebx, -1             ; ebx = -1 (negativo)
    inc esi
    jmp .atoi_digitos
.atoi_positivo:
    cmp cl, '+'
    jne .atoi_digitos
    inc esi

.atoi_digitos:
    mov cl, [esi]
    cmp cl, '0'
    jl  .atoi_fin
    cmp cl, '9'
    jg  .atoi_fin
    imul eax, eax, 10       ; eax = eax * 10
    sub  cl, '0'            ; valor numerico del digito
    movzx ecx, cl           ; extender a 32 bits
    add  eax, ecx           ; acumular digito
    inc  esi
    jmp  .atoi_digitos

.atoi_fin:
    imul eax, ebx           ; aplicar signo: eax * 1 o eax * -1
    pop ecx
    pop ebx
    pop esi
    ret

itoa:
    push esi
    push edi
    push ebx
    push ecx

    mov esi, edx            ; esi = inicio del buffer (para restaurar edx al final)
    mov edi, edx            ; edi = puntero de escritura
    xor ebx, ebx            ; ebx = contador de digitos apilados

.itoa_signo:
    test eax, eax           ; eax es negativo?
    jge .itoa_cero
    mov byte[edi], '-'      ; escribir signo menos
    inc edi
    neg eax                 ; convertir a valor absoluto

.itoa_cero:
    test eax, eax           ; caso especial: cero
    jnz .itoa_extraer
    push dword 0            ; apilar el digito 0
    inc ebx
    jmp .itoa_escribir

.itoa_extraer:
    test eax, eax           ; quedan digitos?
    jz  .itoa_escribir
    xor edx, edx            ; limpiar edx antes de div
    mov ecx, 10             ; divisor = 10
    div ecx                 ; eax = cociente, edx = digito actual
    push edx                ; apilar digito (menos significativo primero)
    inc ebx
    jmp .itoa_extraer

.itoa_escribir:
    test ebx, ebx           ; quedan digitos en la pila?
    jz  .itoa_fin
    pop ecx                 ; sacar digito (LIFO: sale el mas significativo)
    add cl, '0'             ; convertir a ASCII
    mov [edi], cl
    inc edi
    dec ebx
    jmp .itoa_escribir

.itoa_fin:
    mov byte[edi], 0        ; nulo de fin de cadena
    mov edx, esi            ; restaurar edx = inicio del buffer
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret

section .data
    msg_captura  db 0xa, 'Ingrese 5 numeros enteros:', 0xa, 0
    msg_elemento db 'Numero: ', 0
    msg_original db 0xa, 'Arreglo original: ', 0
    msg_ordenado db 0xa, 'Arreglo ordenado: ', 0
    lencad       db 64
    len          db 5

section .bss
    cad          resb 64
    arr          resd 5     ; 5 elementos de 32 bits = 20 bytes