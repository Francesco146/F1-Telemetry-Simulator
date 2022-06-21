.section .text
    .global str2int

# Converte in intero la stringa in %ESI terminata dal carattere in %CL
# Output in %EAX ed %ESI che punta al carattere dopo il numerale
.type str2int, @function
str2int:
    push %ebx               # backup dei registri
    push %edx

    xor %eax, %eax          # registro per risultato
    xor %ebx, %ebx          # registro per carattere

while:
    mov (%esi), %bl         # copio il carattere in %BL

    cmp $0, %bl             # controllo di non essere a fine input
    je end
    
    cmp %cl, %bl            # controllo se e' stato letto il carattere in %CL
    je end

    sub $48, %bl            # converto il codice ASCII della cifra nella cifra corrisp.
    mov $10, %edx           # moltiplicatore
    mul %edx                # %EAX *= 10
    add %ebx, %eax          # sommo la cifra convertita al numero

    inc %esi                # prossimo carattere
    jmp while
end:
    pop %edx                # ripristino i registri utilizzati
    pop %ebx
    ret
