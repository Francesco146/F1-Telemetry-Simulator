.section .data
pilot_0_str:
    .string   "Pierre Gasly\0"
pilot_1_str:
    .string   "Charles Leclerc\0"
pilot_2_str:
    .string   "Max Verstappen\0"
pilot_3_str:                       
    .string   "Lando Norris\0"
pilot_4_str:
    .string   "Sebastian Vettel\0"
pilot_5_str:
    .string   "Daniel Ricciardo\0"
pilot_6_str: 
    .string   "Lance Stroll\0"
pilot_7_str:
    .string   "Carlos Sainz\0"
pilot_8_str:
    .string   "Antonio Giovinazzi\0"
pilot_9_str:
    .string   "Kevin Magnussen\0"
pilot_10_str:
    .string  "Alexander Albon\0"
pilot_11_str:
    .string  "Nicholas Latifi\0"
pilot_12_str:
    .string  "Lewis Hamilton\0"
pilot_13_str:
    .string  "Romain Grosjean\0"
pilot_14_str:
    .string  "George Russell\0"
pilot_15_str:
    .string  "Sergio Perez\0"
pilot_16_str:
    .string  "Daniil Kvyat\0"
pilot_17_str:
    .string  "Kimi Raikkonen\0"
pilot_18_str:
    .string  "Esteban Ocon\0"
pilot_19_str:
    .string  "Valtteri Bottas\0"

pilots_array:
    .long pilot_0_str
    .long pilot_1_str
    .long pilot_2_str
    .long pilot_3_str
    .long pilot_4_str
    .long pilot_5_str
    .long pilot_6_str
    .long pilot_7_str
    .long pilot_8_str
    .long pilot_9_str
    .long pilot_10_str
    .long pilot_11_str
    .long pilot_12_str
    .long pilot_13_str
    .long pilot_14_str
    .long pilot_15_str
    .long pilot_16_str
    .long pilot_17_str
    .long pilot_18_str
pilots_array_end:
    .long pilot_19_str

.section .text
    .global get_pilot

# Ricava l'id del pilota associato al nome presente nella riga corrente
# Output in %EBX
.type get_pilot, @function
get_pilot:
    lea pilots_array_end, %ebx    # metto in %EBX l'indirizzo del puntatore all'ultima stringa
    mov $10, %dl                  # \n per il fine riga

while:
    mov (%ebx), %eax              # metto in %EAX l'indirizzo della stringa puntata da %EBX
    call are_strings_equal        # confronto %ESI ed %EAX
    cmp $1, %ecx                  # se ritorna 1 ho trovato il mio pilota
    je trovato

    sub $4, %ebx                  # altrimenti decremento il puntatore
    cmp $pilots_array, %ebx       # controllo se mi rimangono stringhe
    jge while

    mov $-1, %ebx                 # pilota non trovato
    jmp end
trovato:                          # ricavo l'id in %EBX
    sub $pilots_array, %ebx       # sottraggo dall'indirizzo dell'elemento dell'array
                                  # l'indirizzo del primo elemento dell'array
    shr $2, %ebx                  # divido per sizeof long, ovvero shift di 2
end:
    ret
