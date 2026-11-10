INCLUDE Irvine32.inc 
INCLUDE Bomberman.inc 

.stack 4096

;Makes finish accessible to other asm files
PUBLIC finish

.data

; Startup message
startMessage BYTE "Press W to begin",0


; Variables we will use to keep track of the player
xPos BYTE 0
yPos BYTE 0
map BYTE (MAP_WIDTH * MAP_HEIGHT) DUP(?)

; Indicates whether the game has ended
finish BYTE 0

.code
main PROC

    ; Initialize random number generator for map generation
    call Randomize

    ; Display the start screen
    mov dh,15
    mov dl,55
    call GoToXY
    mov edx,OFFSET startMessage
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

     ;mov edx,OFFSET myString2
     ;call WriteString
     call GenMap
     mov xPos, 1
     mov yPos, 1
     
     call DisplayMap

    game:
     call GetMove

     cmp al, 1
     jne CheckFinish

     call ProcessTurn

CheckFinish:

    cmp finish, 1
    je gameEnd

    jmp game

gameEnd:
exit
    
    ;INVOKE ExitProcess, 0
    ;using exit from irvine instead of doing exitprocess

main ENDP
END main
