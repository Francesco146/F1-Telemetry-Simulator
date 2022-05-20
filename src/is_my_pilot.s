.section .text
    .global is_my_pilot

# Controlla se la riga corrente in %ESI riguarda il pilota in %EAX
# Valore di ritorno in %ECX
.type is_my_pilot, @function
is_my_pilot:
    push %esi

is_my_pilot_while:
    mov (%esi), %cl         # copio il carattere
    inc %esi                # sposto il puntatore
    cmp %dl, %cl            # controllo se ho consumato il campo tempo
    jne is_my_pilot_while

    call are_strings_equal  # confronto l'id pilota con il campo pilota
                            # in %DL ho già il separatore
    pop %esi
    ret                     # in %ECX ho T/F
