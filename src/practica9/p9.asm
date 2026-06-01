
%macro FOR 4
    push ecx
    push edx
    mov  ecx, %1
    mov  edx, %2
    .%4:
    call %3
    loop .%4
    pop  edx
    pop  ecx
%endmacro

global maximo
global minimo
global sumatoria

section .text

comparar_max:
    push ebx
    push esi
    push edi
    mov  esi, [arr_ptr]
    mov  edi, [arr_idx]
    mov  ebx, [esi + edi*4]     ; ebx = arr[arr_idx]
    cmp  ebx, [max_actual]         ; arr[idx] > max_actual?
    jle  .salir_max
    mov  [max_actual], ebx         ; actualizar maximo
.salir_max:
    inc  dword[arr_idx]
    pop  edi
    pop  esi
    pop  ebx
    ret

comparar_min:
    push ebx
    push esi
    push edi
    mov  esi, [arr_ptr]
    mov  edi, [arr_idx]
    mov  ebx, [esi + edi*4]
    cmp  ebx, [min_actual]         ; arr[idx] < min_actual?
    jge  .salir_min
    mov  [min_actual], ebx         ; actualizar minimo
.salir_min:
    inc  dword[arr_idx]
    pop  edi
    pop  esi
    pop  ebx
    ret


sumar:
    push ebx
    push esi
    push edi
    mov  esi, [arr_ptr]
    mov  edi, [arr_idx]
    mov  ebx, [esi + edi*4]
    add  dword[sumatoria_actual], ebx    ; sumatoria_actual += arr[arr_idx]
    inc  dword[arr_idx]
    pop  edi
    pop  esi
    pop  ebx
    ret


maximo:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx

    mov  esi, [ebp + 8]
    mov  eax, [esi]
    mov  [max_actual], eax         ; max_actual = arr[0] (maximo inicial)
    mov  [arr_ptr], esi
    mov  dword[arr_idx], 1      ; empezar desde indice 1
    mov  ecx, [ebp + 12]
    dec  ecx                    ; len - 1 iteraciones
    cmp  ecx, 0
    jle  .fin_maximo            ; len == 1, ya tenemos el maximo
    FOR  ecx, esi, comparar_max, cicloMaximo

.fin_maximo:
    mov  eax, [max_actual]
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret

minimo:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx

    mov  esi, [ebp + 8]
    mov  eax, [esi]
    mov  [min_actual], eax         ; min_actual = arr[0] (minimo inicial)
    mov  [arr_ptr], esi
    mov  dword[arr_idx], 1
    mov  ecx, [ebp + 12]
    dec  ecx
    cmp  ecx, 0
    jle  .fin_minimo
    FOR  ecx, esi, comparar_min, cicloMinimo

.fin_minimo:
    mov  eax, [min_actual]
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret


sumatoria:
    push ebp
    mov  ebp, esp
    push ebx
    push ecx
    push edx

    mov  esi, [ebp + 8]
    mov  dword[sumatoria_actual], 0      ; acumulador = 0
    mov  [arr_ptr], esi
    mov  dword[arr_idx], 0      ; empezar desde indice 0
    mov  ecx, [ebp + 12]
    cmp  ecx, 0
    jle  .fin_sumatoria
    FOR  ecx, esi, sumar, cicloSumatoria

.fin_sumatoria:
    mov  eax, [sumatoria_actual]
    pop  edx
    pop  ecx
    pop  ebx
    pop  ebp
    ret

section .data
    max_actual  dd 0               ; maximo actual
    min_actual  dd 0               ; minimo actual
    sumatoria_actual  dd 0               ; sumatoria actual
    arr_ptr  dd 0               ; puntero al inicio del arreglo
    arr_idx  dd 0               ; indice actual del recorrido
