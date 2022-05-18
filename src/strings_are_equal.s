.section .text
    .global strings_are_equal

# controlla se le due stringhe in %eax e %esi sono sono uguali.
# La prima è terminata da \0 mentre la seconda da %edx
.type strings_are_equal, @function
strings_are_equal:
    push %ebx
    push %edx
    xor %ecx, %ecx
strings_are_equal_while:
    mov (%eax, %ecx, 1), %bl
    mov (%esi, %ecx, 1), %dl
    cmp $0, %bl
    je strings_are_equal_maybe # se sono a fine stringa controllo che l'altra abbia \n
    cmp %bl, %dl
    jne strings_are_equal_false # altrimenti se i caratteri sono diversi sono diverse
    inc %ecx
    jmp strings_are_equal_while

strings_are_equal_maybe:
    cmp (%esp), %dl # %edx appena chiamata la funzione
    jne strings_are_equal_false
    mov $0, %ecx # ho trovato il pilota
    jmp strings_are_equal_fine
strings_are_equal_false:
    mov $1, %ecx
strings_are_equal_fine:
    pop %edx
    pop %ebx
    ret
