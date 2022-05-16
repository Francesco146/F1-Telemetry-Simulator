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

    call get_pilot # ho l'id pilota in ecx

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
