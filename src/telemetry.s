.section .data
pilot_id:
    .string "\0\0\0"
invalid_pilot_str:	
    .string "Invalid\0"

.section .text
    .global telemetry
telemetry:
    # salvo il valore di ebp
    push %ebp
    mov %esp, %ebp
    # salvo gli altri registri
    push %eax
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi
    
    mov 8(%ebp), %esi # carico l'input in esi

    call get_pilot # ho l'id pilota in ebx
    cmp $0, %ebx
    jl invalid

    lea pilot_id, %edi # carico in edi l'indirizzo di destinazione
    call int2str # converto l'id in ebx in stringa
    lea pilot_id, %eax # carico in %EAX l'indirizzo dell'id

    mov 12(%ebp), %edi # carico l'output in edi

    call next_line # consumo la riga con il nome pilota
while_telemetry:
    # controlla se il pilota è valido
    # elabora la riga

    # altrimenti passa alla prossima riga
    call next_line

    mov (%esi), %bl # controllo se sono a fine input
    cmp $0, %bl
    jne while_telemetry

    # output di avg e max

    jmp fine
invalid:
    mov 12(%ebp), %edi # carico l'output in edi
    # printo pilota non valido
fine:
    # ripristino i registri
    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    # ripristino ebp (e anche esp)
    pop %ebp
    ret
