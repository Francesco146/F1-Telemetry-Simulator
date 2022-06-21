.section .data

speed_value: .long 0
rpm_value: .long 0
temp_value: .long 0

high_str: .string "HIGH\0"
medium_str: .string "MEDIUM\0"
low_str: .string "LOW\0"

# Processa la riga corrente, aggiorna i massimi e la media e scrive in output i livelli
.section .text
    .global process_line

.type process_line, @function
process_line:
    push %edx              # backup dei registri
    push %ecx
    push %ebx
    push %eax

process_time_while:        # copio il tempo da %ESI ad %EDI finchè non trovo ','
    mov (%esi), %dl
    mov %dl, (%edi)
    inc %esi
    inc %edi
    cmp $44, %dl
    jne process_time_while

while_skip_pilot:          # consumo il campo pilota scorrendo la stringa di input
    mov (%esi), %dl
    inc %esi
    cmp $44, %dl
    jne while_skip_pilot

    # converto in intero i campi e li salvo nelle rispettive variabili
    mov $44, %cl           # terminatore del campo, ovvero ','
    call str2int
    mov %eax, speed_value
    inc %esi               # sposto %ESI al prossimo campo

    call str2int
    mov %eax, rpm_value
    inc %esi

    mov $10, %cl           # terminatore dell'ultimo campo, ovvero '\n'
    call str2int
    mov %eax, temp_value

    # output dei livelli su %EDI e aggiorno i valori massimi
# rpm
    mov rpm_value, %eax
    cmp %eax, max_rpm      
    jg no_max_rpm          # se il valore è più grande del massimo corrente, 
    mov %eax, max_rpm      # aggiorno il mio massimo
  no_max_rpm:              # altrimenti mi limito a ricavare il livello
    mov $5000, %ebx        # carico gli intervalli per i liverlli
    mov $10000, %ecx
    call output_levels     # scrivo in output i livelli
    movb $44, (%edi)       # inserisco in output la ','
    inc %edi               # sposto %ESI al prossimo campo

# temperatura
    mov temp_value, %eax
    cmp %eax, max_temp
    jg no_max_temp
    mov %eax, max_temp
no_max_temp:
    mov $90, %ebx
    mov $110, %ecx
    call output_levels
    movb $44, (%edi)
    inc %edi

# velocità
    mov speed_value, %eax

    # incremento counter_speed e sum_speed per la velocità media
    inc counter_speed
    add %eax, sum_speed

    cmp %eax, max_speed
    jg no_max_speed
    mov %eax, max_speed
no_max_speed:
    mov $100, %ebx
    mov $250, %ecx
    call output_levels
    movb $10, (%edi)
    inc %edi

    # ripristino i registri
    pop %eax
    pop %ebx
    pop %ecx
    pop %edx
    ret

# Confronta il valore in %EAX rispetto al valore minimo in %EBX e il massimo in %ECX
# Output in %EDI
.type output_levels, @function
output_levels:
    cmp %ebx, %eax        # individuo il livello associato al valore
    jle load_low
    cmp %ecx, %eax
    jle load_medium
    jmp load_high         # se non è LOW ne MEDIUM, allora è per forza HIGH
  load_low:
    lea low_str, %eax     # carico la stringa in %EAX
    jmp print
  load_medium:
    lea medium_str, %eax
    jmp print
  load_high:
    lea high_str, %eax
  print:                  # copio char per char il livello in output
    mov (%eax), %bl
    mov %bl, (%edi)

    cmp $0, %bl           # termino se arrivo a \0
    je fine

    inc %eax
    inc %edi
    jmp print

fine:
    ret
