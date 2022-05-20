.section .data
pilot_id:
    .string "\0\0\0"
invalid_pilot_str:	
    .string "Invalid\0"

.section .text
    .global telemetry
telemetry:
    push %ebp               # salvo il valore di %EBP
    mov %esp, %ebp
    push %eax               # salvo gli altri registri
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi

    mov 8(%ebp), %esi       # carico l'input in %ESI

    call get_pilot          # ricavo l'id pilota in %EBX
    cmp $0, %ebx
    jl telemetry_invalid

    lea pilot_id, %edi      # carico in %EDI l'indirizzo di destinazione
    call int2str            # converto l'id in stringa
    lea pilot_id, %eax      # ri-carico in %EAX l'indirizzo della stringa

    call next_line          # consumo la riga con il nome pilota

    mov 12(%ebp), %edi      # carico l'output in %EDI
    mov $44, %dl            # in %DL il separatore dei campi
telemetry_while:
    call is_my_pilot        # se è il pilota monitorato
    cmp $0, %ecx
    jz telemetry_next_line

    # call                  # elaboro la riga corrente
    jmp telemetry_line_done
telemetry_next_line:
    call next_line          # altrimenti passo alla riga successiva
telemetry_line_done:
    mov (%esi), %bl         # controllo se sono a fine input
    cmp $0, %bl
    jne telemetry_while

    # call                  # stampo massimi e media

    jmp telemetry_end
telemetry_invalid:
    mov 12(%ebp), %edi      # carico l'output in %EDI
                            # stampo pilota non valido
telemetry_end:
    pop %edi                # ripristino i registri
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    pop %ebp                # ripristino %EBP (e anche %ESP)
    ret
