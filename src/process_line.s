.section .data

.section .text
    .global process_line

.type process_line, @function
process_line:
    # backup dei registri
    push %edx
    push %ecx
    push %ebx
    push %eax

    # copio il tempo da %ESI ad %EDI finchè non trovo ','

    # consumo il campo pilota scorrendo la stringa di input

    # parsing dei campi e mov dell'output nelle variabili
    mov $44, %cl # terminatore del campo
    # call str2int

    # output dei livelli su %EDI e computo dei max

    # incremento counter_speed e sum_speed per la velocità media

    # ripristino i registri
    pop %eax
    pop %ebx
    pop %ecx
    pop %edx
    ret
