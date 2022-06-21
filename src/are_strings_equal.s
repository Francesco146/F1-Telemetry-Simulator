.section .text
    .global are_strings_equal

# Controlla se le due stringhe in %EAX e %ESI sono sono uguali.
# La prima è terminata da \0 mentre la seconda da %DL.
# Output in %ECX
.type are_strings_equal, @function
are_strings_equal:
    push %ebx
    push %edx
    xor %ecx, %ecx
while:
    mov (%eax, %ecx, 1), %bl
    mov (%esi, %ecx, 1), %dl
    cmp $0, %bl                 # se sono alla fine di %EAX
    je maybe                    # controllo che %ESI sia terminata da %DL
    cmp %bl, %dl                # se invece i caratteri sono diversi
    jne false                   # le stringhe sono diverse
    inc %ecx                    # altrimenti passo al carattere successivo
    jmp while

maybe:
    mov (%esp), %bl            # ripristino il terminatore in %BL
    cmp %bl, %dl
    jne false
    mov $1, %ecx               # le stringhe sono uguali
    jmp end
false:
    mov $0, %ecx               # le stringhe sono diverse
end:
    pop %edx
    pop %ebx
    ret
