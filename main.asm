INCLUDE Irvine32.inc 
INCLUDE Bomberman.inc 

.stack 4096

;Makes finish accessible to other asm files
PUBLIC finish

.data

; Startup message
startMessage BYTE "Press W to begin",0


; End game messages
gameOverMessage BYTE "GAME OVER!", 0
victoryMessage BYTE "Level Complete!",0
restartMessage BYTE "Press R to restart or Q to quit",0

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


StartGame:


    ; Reset game
    mov finish, 0
    mov xPos, 1
    mov yPos, 1


    ; Clrscr and generate new map
    call Clrscr
    call GenMap


    call DisplayMap

   
StartScreen:
    
    call ReadChar
    and AL, 0DFh

    cmp al,'W'
    je Begin

    jmp StartScreen
     
     
; Begin the game
Begin:
    
    ; Clears the start screen
    call clrscr

    ; Generates a new map and inits player pos
    call GenMap


    mov xPos, 1
    mov yPos, 1
     
    ; Displays the randomly generated map
    call DisplayMap

Game:

    ; Reads the player input
    call GetMove

    ; processes bomb countdown after a successful movement
    cmp al, 1
    jne CheckFinish

    call ProcessTurn

CheckFinish:

    ; Checks whether player lost or beat the game
    cmp finish, 1
    je GameEnd


    ; Check if player found the exit
    cmp finish, 2
    je Victory


    jmp Game


Victory:


    call Clrscr

    mov dh, 15
    mov dl, 55
    call GoToXY


    mov edx, OFFSET victoryMessage
    call WriteString


    jmp ExitGame


GameEnd:


ExitGame:


    ; exits the game = Equivalent to EXITPROCESS
    exit
    
    

main ENDP

END main
