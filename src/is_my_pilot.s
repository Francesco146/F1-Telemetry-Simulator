.section .text
    .global is_my_pilot

# Controlla se la riga corrente in %ESI riguarda il pilota in %EAX
# Valore di ritorno in %ECX
.type is_my_pilot, @function
is_my_pilot:
    push %esi               # salvo %ESI perchè non va modificato

while_tempo:                # consumo il campo 'tempo'
    mov (%esi), %cl         # copio il carattere
    inc %esi                # sposto il puntatore
    cmp %dl, %cl            # controllo se ho consumato il campo tempo
    jne while_tempo

    call are_strings_equal  # confronto l'id pilota (in %EAX) con il campo pilota (in %ESI)
                            # in %DL ho già il separatore
    
    pop %esi                # rispristino %ESI
    ret                     # in %ECX ho T/F
