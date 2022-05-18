.section .data
    numtmp: .ascii "00000000000"     # temporary string

.section .text
    .global int2str

# trasforma l'intero in ebx nella stringa in edi
.type int2str, @function
int2str:
    push %esi
    push %edx
    push %ecx
    push %ebx
    push %eax

    mov %ebx, %eax            # sposto il numero in EAX
    xor %ecx, %ecx            # azzera il contatore ECX
    mov $10, %ebx             # 10 per la divisione
    lea numtmp, %esi          # carica l'indirizzo di 'numtmp' in ESI

continua_a_dividere:
    xor %edx, %edx            # azzera il contenuto di EDX
    div %ebx                  # divide per 10 il numero ottenuto
    add $48, %dl              # aggiunge 48 al resto della divisione
    mov %dl, (%esi,%ecx,1)    # sposta il contenuto di DL in numtmp
    inc %ecx                  # incrementa il contatore ECX
    cmp $0, %eax              # controlla se il contenuto di EAX è 0
    jne continua_a_dividere

    xor %edx, %edx            # azzera un secondo contatore in EDX

ribalta:
    mov -1(%esi, %ecx,1), %al  # carica in AL il contenuto dell'ultimo byte di 'numtmp'
    mov %al, (%edi)            # carica nel primo byte di EDI il contenuto di AL

    inc %edi                   # incrementa EDX
    loop ribalta               # decrementa ECX

    pop %eax
    pop %ebx
    pop %ecx
    pop %edx
    pop %esi
    ret
