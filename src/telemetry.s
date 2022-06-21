.section .data
pilot_id:
    .string "\0\0\0"
invalid_pilot_str:	
    .string "Invalid\n\0"
    
counter_speed: .global counter_speed
    .long 0
sum_speed: .global sum_speed
    .long 0
max_speed: .global max_speed
    .long 0
max_rpm: .global max_rpm
    .long 0
max_temp: .global max_temp
    .long 0

.section .text
    .global telemetry
telemetry:
    push %ebp               # salvo il valore di %EBP (base pointer)
    mov %esp, %ebp
    push %eax               # salvo gli altri registri
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi

    mov 8(%ebp), %esi       # carico l'indirizzo dell'input in %ESI

    call get_pilot          # ricavo l'id pilota in %EBX
    cmp $0, %ebx
    jl pilot_is_invalid

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

    call process_line       # elaboro la riga corrente
    jmp telemetry_line_done
telemetry_next_line:
    call next_line          # altrimenti passo alla riga successiva
telemetry_line_done:
    mov (%esi), %bl         # controllo se sono a fine input
    cmp $0, %bl
    jne telemetry_while

    call output_max_avg     # stampo massimi e media
    movb $0, (%edi)         # aggiungo '\0'

    jmp telemetry_end

pilot_is_invalid:
    mov 12(%ebp), %edi      # carico l'output in %EDI
    lea invalid_pilot_str, %eax
while_print_invalid:        # copio char per char "Invalid" in output
    mov (%eax), %dl
    mov %dl, (%edi)
    inc %eax
    inc %edi
    cmp $0, %dl
    jne while_print_invalid

telemetry_end:
    pop %edi                # ripristino i registri
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    pop %ebp                # ripristino %EBP (e anche %ESP)
    ret
