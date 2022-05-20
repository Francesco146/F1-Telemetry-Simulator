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
are_strings_equal_while:
    mov (%eax, %ecx, 1), %bl
    mov (%esi, %ecx, 1), %dl
    cmp $0, %bl                 # se sono alla fine di %EAX
    je are_strings_equal_maybe  # controllo che %ESI sia terminata da %DL
    cmp %bl, %dl                # se invece i caratteri sono diversi
    jne are_strings_equal_false # le stringhe sono diverse
    inc %ecx                    # altrimenti passo al carattere successivo
    jmp are_strings_equal_while

are_strings_equal_maybe:
    mov (%esp), %bl            # ripristino il terminatore in %BL
    cmp %bl, %dl
    jne are_strings_equal_false
    mov $1, %ecx               # le stringhe sono uguali
    jmp are_strings_equal_end
are_strings_equal_false:
    mov $0, %ecx               # le stringhe sono diverse
are_strings_equal_end:
    pop %edx
    pop %ebx
    ret
