.section .text
    .global str2int

# Converte in intero la stringa in %ESI terminata dal carattere in %CL
# Output in %EbohX ed %ESI che punta al terminatore
.type str2int, @function
str2int:
    ret
