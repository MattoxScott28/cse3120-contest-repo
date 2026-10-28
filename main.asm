INCLUDE Irvine32.inc
; INCLUDE Bomberman.inc this line currently causes a conflict

ExitProcess PROTO, dwExitCode:DWORD

.data
myString BYTE "Press W to begin",0
myString2 BYTE "PLACEHOLDER Game has begun",0
.code
main PROC

    mov dh,15
    mov dl,55
    call GoToXY
    mov edx,OFFSET myString
    call WriteString
    
    INVOKE ExitProcess, 0

main ENDP
END main
