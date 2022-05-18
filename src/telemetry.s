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
    
    # +4 perchè c'è anche ebp
    mov 8(%ebp), %esi
    mov 12(%ebp), %edi

    call get_pilot # ho l'id pilota in ebx
    cmp $0, %ebx
    jl invalid

    # int2str in pilot_id

    call next_line
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
