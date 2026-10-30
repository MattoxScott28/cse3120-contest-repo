;i actually might be stupid
.stack 4096

INCLUDE Irvine32.inc ; This one probably declares the model?
INCLUDE Bomberman.inc 

ExitProcess PROTO, dwExitCode:DWORD

.data
myString BYTE "Press W to begin",0
myString2 BYTE "PLACEHOLDER Game has begun",0
.code
main PROC

    ; Set the cursor to the center of the screen and write Press W to begin
    mov dh,15
    mov dl,55
    call GoToXY
    mov edx,OFFSET myString
    call WriteString
    
    
    ; Loop until W is pressed by the user, once it is enter the begin label
    StartScreen:
     call ReadChar
     and AL, 0DFh
     cmp al,'W'
     je begin
     jmp StartScreen
     
     
    ; Begin the game
    begin:
     call clrscr
     mov edx,OFFSET myString2
     call WriteString
    
    INVOKE ExitProcess, 0

main ENDP
END main
