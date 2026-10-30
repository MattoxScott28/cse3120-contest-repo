INCLUDE Irvine32.inc

.code
main PROC

    mov edx, OFFSET message
    call WriteString

    call ReadChar

    exit
main ENDP

.data
message BYTE "Irvine32 is working!", 0

END main