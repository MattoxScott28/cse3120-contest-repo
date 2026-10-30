INCLUDE Irvine32.inc

.data
message BYTE "Bomberman is working!", 0

.code
main PROC

    mov edx, OFFSET message
    call WriteString

    call ReadChar

    exit
main ENDP

END main