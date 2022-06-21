.section .text
    .global output_max_avg

# scrivo in %EDI i massimi e la velocità media
.type output_max_avg, @function
output_max_avg:
    mov max_rpm, %ebx       # copio il valore in %EBX
    call int2str            # converto il valore in stringa
    movb $44, (%edi)        # aggiungo il carattere ',' in output
    inc %edi                # salto la virgola appena aggiunta

    mov max_temp, %ebx
    call int2str
    movb $44, (%edi)
    inc %edi

    mov max_speed, %ebx
    call int2str
    movb $44, (%edi)
    inc %edi

    xor %edx, %edx          # azzero %EDX per la divisione
    mov counter_speed, %ebx # copio il divisore in %EBX
    cmp $0, %ebx            # se il contatore è a 0
    je zero_avg             # scrivo media di 0

    mov sum_speed, %eax     # altrimenti copio il dividendo in %EAX
    div %ebx                # calcolo la media in %EAX
    mov %eax, %ebx          # int2str vuole il numero in %EBX
zero_avg:
    call int2str            # converto la media in stringa

    movb $10, (%edi)        # aggiungo il carattere \n
    inc %edi                # salto il carattere \n appena aggiunto

    ret
