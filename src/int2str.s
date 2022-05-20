.section .data
numtmp: .ascii "00000000000" # stringa temporanea

.section .text
    .global int2str

# Converte l'intero in %EBX nella stringa in %EDI
.type int2str, @function
int2str:
    push %esi
    push %edx
    push %ecx
    push %ebx
    push %eax

    mov %ebx, %eax          # sposto il numero in %EAX
    xor %ecx, %ecx          # azzero il contatore %ECX
    mov $10, %ebx           # 10 per la divisione
    lea numtmp, %esi        # carico l'indirizzo di 'numtmp' in %ESI

int2str_while:
    xor %edx, %edx
    div %ebx                # in %EDX il resto della divisione
    add $48, %dl            # aggiungo 48 al resto
    mov %dl, (%esi,%ecx,1)  # sposto il contenuto di %DL in numtmp
    inc %ecx
    cmp $0, %eax            # controllo se il contenuto di %EAX è 0
    jne int2str_while

int2string_ribalta:
    mov -1(%esi, %ecx,1), %al # carico in %AL il contenuto dell'ultimo byte di 'numtmp'
    mov %al, (%edi)         # carico nel primo byte di %EDI il contenuto di %AL

    inc %edi
    loop int2string_ribalta # decremento %ECX

    pop %eax
    pop %ebx
    pop %ecx
    pop %edx
    pop %esi
    ret
