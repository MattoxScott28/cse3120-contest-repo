INCLUDE Irvine32.inc
INCLUDE Bomberman.inc


.data


; Stores the pos and countdown of the curr bomb
bombX BYTE 0
bombY BYTE 0
activeBomb BYTE 0
bombTurns BYTE 0


.code


PUBLIC GetMove
PUBLIC ProcessTurn


; Reads player input and handles both movement and bomb placement
GetMove PROC


	; Reads a key (shocker)
	call ReadChar
	and AL, 0DFh
  


	; Check for upward movement, if key = 'W' then you go up
	cmp al, 'W'
	je Up
	cmp ah, 48h
	je Up

	; Check for left movement
	cmp al, 'A'
	je Left
	cmp ah, 4Bh
	je Left

	; Check for down movement
	cmp al, 'S'
	je Down
	cmp ah, 50h
	je Down

	; Compare the key input with the D key and Right arrow, if equal, the character moves right
	cmp al, 'D'
	je Right
	cmp ah,4Dh
	je Right
	

	; Checks if the player wants to enter bomb placing mode
	cmp al, 'E'
	je Bomberman


	; If all else fails
	jmp Invalid


Up:


	; Check if map[playerX][playerY-1] is an available space
	cmp yPos, 1
	je Invalid


	; Calculates the map index of the desination tile
	movzx eax, yPos
	dec eax
	imul eax, MAP_WIDTH


	movzx ebx, xPos
	add eax,ebx


	; Checks if desination tile is available
	mov dl, map[eax] 


	; If the tile the player is trying to move to is a wall, block, or bomb, jump to Invalid
	cmp dl, WALL
	je Invalid


	cmp dl, BLOCK
	je Invalid


	cmp dl, 'B'
	je Invalid


	; Check whether the player has reached the exit
	cmp dl, EXIT_TILE
	jne ContinueMoveUp


	mov finish, 2


	ContinueMoveUp:


	; Clears the player's prev pos
	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx


	INVOKE UpdateTile, eax, EMPTY


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, EMPTY


	; Updates player position
	dec yPos

	; Places player at the new pos
	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx
	

	INVOKE UpdateTile, eax, PLAYER


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, PLAYER


	mov al, 1


	ret


Left:


	; Check if map[playerX-1][playerY] is an available space
	cmp xPos, 1
	je Invalid


	; Calculates the map index of the destination tile
	movzx eax, yPos
	imul eax, MAP_WIDTH


	movzx ebx, xPos
	dec ebx
	add eax,ebx


	; Checks whether the desination tile is available
	mov dl, map[eax] ; READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED


	cmp dl, WALL
	je Invalid


	cmp dl, BLOCK
	je Invalid


	cmp dl, 'B'
	je Invalid


	; Check whether the player has reached the exit
	cmp dl, EXIT_TILE
	jne ContinueMoveLeft


	mov finish, 2


	ContinueMoveLeft:


	; remove from old position
	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx


	INVOKE UpdateTile, eax, EMPTY


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, EMPTY


	; Updates the player's position
	dec xPos


	; Places the player at the new pos
	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx


	INVOKE UpdateTile, eax, PLAYER


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, PLAYER

	mov al, 1


	ret

; The code for Down and Right are literally the same as Up and Down except for some specific increments/decrements
Down:


	; Check if map[playerX][playerY+1] is an available space
	cmp yPos, MAP_HEIGHT-2
	je Invalid


	movzx eax, yPos
	inc eax
	imul eax, MAP_WIDTH


	movzx ebx, xPos
	add eax,ebx
	mov dl, map[eax] ; READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED


	; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
	cmp dl, WALL
	je Invalid
	

	cmp dl, BLOCK
	je Invalid


	cmp dl, 'B'
	je Invalid


	; Check whether the player has reached the exit
	cmp dl, EXIT_TILE
	jne ContinueMoveDown


	mov finish, 2


	ContinueMoveDown:

	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx


	INVOKE UpdateTile, eax, EMPTY


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, EMPTY


	inc yPos


	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx
	

	INVOKE UpdateTile, eax, PLAYER


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, PLAYER


	mov al, 1


	ret


Right:


	; Check if map[playerX+1][playerY] is an available space
	cmp xPos, MAP_WIDTH-2
	je Invalid


	movzx eax, yPos
	imul eax, MAP_WIDTH


	movzx ebx, xPos
	inc ebx
	add eax,ebx


	mov dl, map[eax] ; READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED


	; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
	cmp dl, WALL
	je Invalid


	cmp dl, BLOCK
	je Invalid


	cmp dl, 'B'
	je Invalid


	; Check whether the player has reached the exit
	cmp dl, EXIT_TILE
	jne ContinueMoveRight


	mov finish, 2


	ContinueMoveRight:


	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx


	INVOKE UpdateTile, eax, EMPTY


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, EMPTY


	inc xPos


	movzx eax, yPos
	imul eax, MAP_WIDTH
	movzx ebx, xPos
	add eax, ebx


	INVOKE UpdateTIle, eax, PLAYER


	movzx eax, xPos
	movzx ebx, yPos
	INVOKE DrawSingleTile, eax, ebx, PLAYER


	mov al, 1


	ret


Bomberman:

	; Handles bomb placement
	call PlaceBomb
	ret


Invalid:


	; Return 0 when player performs an invalid action
	mov al, 0


	ret


GetMove ENDP


; Places a bomb in the direction selected by the player
PlaceBomb PROC
	
	
	; Only allow 1 bomb at a time
	cmp activeBomb, 1
	je Dud

	
	; Reads the direction of the bomb placement
	call ReadChar
	and AL, 0DFh


	; Start with the player's curr pos
	movzx ebx, xPos
	movzx edx, yPos


	; Determines bomb destination
	cmp al, 'W'
	je PlaceBombUp
	cmp ah, 48h
	je PlaceBombUp


	cmp al, 'A'
	je PlaceBombLeft
	cmp Ah, 4Bh
	je PlaceBombLeft


	cmp al, 'S'
	je PlaceBombDown
	cmp ah, 50h
	je PlaceBombDown


	cmp al, 'D'
	je PlaceBombRight
	cmp ah, 4Dh
	je PlaceBombRight


	jmp Dud


PlaceBombUp:
	

	dec edx
	jmp CheckBomb


PlaceBombDown:


	inc edx
	jmp CheckBomb


PlaceBombLeft:


	dec ebx
	jmp CheckBomb


PlaceBombRight:


	inc ebx
	jmp CheckBomb



CheckBomb:
	
	; Ensures bomb is inside the playable area of the map
	cmp ebx, 1
	jl Dud
	cmp ebx, MAP_WIDTH-2
	jg Dud


	cmp edx, 1
	jl Dud
	cmp edx, MAP_HEIGHT-2
	jg Dud


	; Calculates the destination of the map index
	mov eax, edx
	imul eax, MAP_WIDTH
	add eax, ebx


	; Only allows bombs on empty spaces
	cmp BYTE PTR map[eax], EMPTY
	jne Dud
	

	; Stores bomb pos
	mov bombX, bl
	mov bombY, dl


	; Places the bomb in the map
	movzx eax, bombY
	imul eax, MAP_WIDTH
	movzx ebx, bombX
	add eax, ebx


	INVOKE UpdateTile, eax, 'B'


	; Displays the bomb
	movzx eax, bombX
	movzx ebx, bombY


	INVOKE DrawSingleTile, eax, ebx, 'B'


	; Activates the bomb and initializes the countdown
	mov activeBomb, 1
	mov bombTurns, 2


	; Returns a code of 2 to indicate the placement of a bomb
	mov al, 2


	ret


Dud:
	

	;Return 0 if bomb placement fails
	mov al, 0


	ret


PlaceBomb ENDP


; Decreases the bomb countdown after each successful turn/movement
ProcessTurn PROC
	

	cmp activeBomb, 1
	jne TurnOver


	dec bombTurns


	cmp bombTurns, 0
	jne TurnOver


	call Explode


TurnOver:


	ret


ProcessTurn ENDP


; Checks if an adjacent tile of the bomb is affected by an explosion
ExplodeTile PROC, blastX:DWORD, blastY:DWORD
	

	push eax
	push ebx


	; Calculates the map index of the affected tile(s)
	mov eax, blastY
	imul eax, MAP_WIDTH
	add eax, blastX

	
	; Reads tile at the calculated pos
	mov bl, map[eax]


	; Walls stop the explosion
	cmp bl, WALL
	je ExplodeDone


	; Destructible blocks are removed
	cmp bl, BLOCK
	je DestroyBlock


	; Check special block
	cmp bl, SPECIAL_BLOCK
	je RevealExit


	; The player blows up and dies
	cmp bl, PLAYER
	je KillPlayer


	jmp ExplodeDone


RevealExit:


	; Replace special block with exit tile
	INVOKE UpdateTile, eax, EXIT_TILE

	
	;Draw revealed exit
	INVOKE DrawSingleTile, blastX, blastY, EXIT_TILE


	jmp ExplodeDone


DestroyBlock:

	
	; Replaces destroyed block with an empty space
	INVOKE UpdateTile, eax, EMPTY


	; Updates block appearance on the screen
	INVOKE DrawSingleTile, blastX, blastY, EMPTY


	jmp ExplodeDone


KillPlayer:

	
	; Game end
	mov finish, 1


ExplodeDone:


	pop ebx
	pop eax
	

	ret


ExplodeTile ENDP


; Checks the four directions around the bomb and removes it
Explode PROC


	; Check tile above bomb
	movzx eax, bombX
	movzx ebx, bombY
	dec ebx


	INVOKE ExplodeTile, eax, ebx


	; Check tile below bomb
	movzx eax, bombX
	movzx ebx, bombY
	inc ebx


	INVOKE ExplodeTile, eax, ebx


	; Check tile left of bomb
	movzx eax, bombX
	dec eax
	movzx ebx, bombY


	INVOKE ExplodeTile, eax, ebx
	

	; Check tile right of bomb
	movzx eax, bombX
	inc eax
	movzx ebx, bombY


	INVOKE ExplodeTile, eax, ebx


	; Caclulates the bomb pos
	movzx eax, bombY
	imul eax, MAP_WIDTH
	movzx ebx, bombX
	add eax, ebx


	; Removes bomb from map
	INVOKE UpdateTile, eax, EMPTY


	; Redraws the bomb tile as empty
	movzx eax, bombX
	movzx ebx, bombY


	INVOKE DrawSingletile, eax, ebx, EMPTY


	; Resets bomb variables
	mov activeBomb, 0
	mov bombTurns, 0


	ret


Explode ENDP


END
