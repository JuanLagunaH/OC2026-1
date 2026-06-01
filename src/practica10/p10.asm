
global set_bit
global get_bit

section .text

set_bit:
    push ebp
    mov  ebp, esp
    push eax
    push ecx
    push edx

    mov  eax, dword[ebp + 8]    ; eax = puntero al unsigned char
    mov  cl,  byte[ebp + 12]    ; cl  = posicion del bit

    mov  dl, 1                  ; dl  = 0000 0001
    shl  dl, cl                 ; dl  = 1 desplazado cl posiciones (mascara)
    or   byte[eax], dl          ; activar el bit: *value |= mascara

    pop  edx
    pop  ecx
    pop  eax
    pop  ebp
    ret

get_bit:
    push ebp
    mov  ebp, esp
    push ecx
    push edx

    mov  eax, dword[ebp + 8]    ; eax = value
    mov  cl,  byte[ebp + 12]    ; cl  = posicion del bit

    mov  edx, 1
    shl  edx, cl                ; edx = mascara del bit (1 << bit)
    test eax, edx               ; bit encendido?
    jz   .get_bit_cero          ; si el resultado es cero, el bit es 0
    mov  eax, 1                 ; bit encendido retornar 1
    jmp  .get_bit_fin
.get_bit_cero:
    mov  eax, 0                 ; bit apagado retornar 0
.get_bit_fin:
    pop  edx
    pop  ecx
    pop  ebp
    ret
