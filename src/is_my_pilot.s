.section .text
    .global is_my_pilot

# controlla se la riga corrente contenuta in %esi riguarda il pilota in %eax
.type is_my_pilot, @function
is_my_pilot:
    push %esi
    push %edx
    push %ebx

    mov $44, %dl # in edx il separatore ,

is_my_pilot_while:
    mov (%esi), %bl # copio il carattere
    inc %esi # sposto il puntatore
    cmp %dl, %bl # controllo se ho consumato il campo del tempo
    jne is_my_pilot_while

    call strings_are_equal # confronto l'id pilota con il campo successivo
    # in ecx ho T/F

    pop %ebx
    pop %edx
    pop %esi # ripristino %esi
    ret
