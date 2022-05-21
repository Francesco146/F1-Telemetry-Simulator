.section .text
    .global output_max_avg

# scrivo in %EDI i massimi e la velocità media
.type output_max_avg, @function
output_max_avg:
    mov max_rmp, %ebx
    call int2str
    movb $44, (%edi) # ,
    inc %edi

    mov max_temp, %ebx
    call int2str
    movb $44, (%edi) # ,
    inc %edi

    mov max_speed, %ebx
    call int2str
    movb $44, (%edi) # ,
    inc %edi

    xor %edx, %edx
    mov counter_speed, %ebx # divisore
    cmp $0, %ebx            # se il contatore è a 0
    je zero_avg             # scrivo media di 0

    mov sum_speed, %eax     # dividendo
    div %ebx                # media in %EAX
    mov %eax, %ebx          # int2str vuole il numero in %EBX
zero_avg:
    call int2str

    movb $10, (%edi)        # aggiungo \n
    inc %edi

    ret
