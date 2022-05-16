.section .data
pilot_id:
    .string "\0\0\0"
invalid_pilot_str:	
    .string "Invalid\0"

.section .text
    .global telemetry
telemetry:
    mov 4(%esp), %esi
    mov 8(%esp), %edi

    call get_pilot

    mov $0, %eax
    ret
