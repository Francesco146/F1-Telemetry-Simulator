.section .text
    .global next_line

# Sposta %ESI alla riga successiva
.type next_line, @function
next_line:
    mov (%esi), %bl         # copio il carattere in %BL
    cmp $0, %bl             # controllo se sono a fine input 
    je fine_input
    cmp $10, %bl            # controllo se sono a fine riga
    je fine_riga
    inc %esi                # sposto %ESI al carattere successivo
    jmp next_line

fine_riga:
    inc %esi                # salto il fine riga '\n'
fine_input:
    ret
