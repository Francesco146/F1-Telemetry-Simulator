.section .text
    .global strings_are_equal

.type strings_are_equal, @function
strings_are_equal:
    push %ebx
    xor %ecx, %ecx
strings_are_equal_while:
    movzbl (%eax, %ecx, 1), %ebx
    movzbl (%esi, %ecx, 1), %edx
    cmp $0, %bl
    je strings_are_equal_maybe # se sono a fine stringa controllo che l'altra abbia \n
    cmp %bl, %dl
    jne strings_are_equal_false # altrimenti se i caratteri sono diversi sono diverse
    inc %ecx
    jmp strings_are_equal_while

strings_are_equal_maybe:
    cmp $10, %dl
    jne strings_are_equal_false
    mov $0, %eax # ho trovato il pilota
    jmp strings_are_equal_fine
strings_are_equal_false:
    mov $1, %eax
strings_are_equal_fine:
    pop %ebx
    ret
