.section .text
    .global next_line

.type next_line, @function
next_line:
    mov (%esi), %bl # copio il carattere in %ebx
    cmp $0, %bl # controllo se sono a fine stringa
    je next_line_end
    cmp $10, %bl # controllo se sono a fine riga
    je next_line_endline
    inc %esi # sposto %esi al carattere successivo
    jmp next_line

next_line_endline:
    inc %esi # elimino il fine riga
next_line_end:
    ret
