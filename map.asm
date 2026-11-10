INCLUDE Irvine32.inc
INCLUDE Bomberman.inc

.data

; Stores the starting address of the curr row while drawing map
rowS DWORD ?


; Stores the randomly selected special block pos
specialX DWORD ?
specialY DWORD ?

; Access shared variables from main
EXTERN map : BYTE
EXTERN xPos : BYTE
EXTERN yPos : BYTE


.code
; Generates a random map with the following
; Permanent border, Destructible Blocks, Player, and a Special Destructible Block meant to send you to the next level
; Special Destructible Block has not been implemented yet
GenMap Proc

	push eax
	push ebx 
	push edi 
	push esi
	
	;ESI points to the curr position in the map array
	mov esi, OFFSET map

	;EBX tracks the curr row
	mov ebx, 0


MapGenR:
	
	;EDI tracks the curr col
	mov edi, 0


MapGenC:

	; Makes the outer border of the map indestructible wall	
	cmp ebx, 0
	je GenWall

	cmp ebx, MAP_HEIGHT-1
	je GenWall

	cmp edi, 0
	je GenWall

	cmp edi, MAP_WIDTH-1
	je GenWall

	; Randomly generates a destructible block or empty space
	mov eax, 4
	; RandomRange is an Irvine command that gives a random number from 0 to EAX-1
	; In this case because EAX = 4, it gives (cmp eax, 0) a 25% chance to be a destructible block
	call RandomRange

	cmp eax, 0
	je GenBlock

	; Generate empty tile
	mov BYTE PTR [esi], EMPTY
	jmp NextCell

GenWall:
	
	; Generates a permanent wall
	mov BYTE PTR [esi], WALL
	jmp NextCell


GenBlock:

	; Generates a destructible block
	mov BYTE PTR [esi], BLOCK


NextCell:

	; Moves to the next pos in the map
	inc esi
	inc edi

	cmp edi, MAP_WIDTH
	jl MapGenC

	; Moves to next row
	inc ebx

	cmp ebx, MAP_HEIGHT
	jl MapGenR

	; Place the player in the upper-left corner of the map that is not an indestructible block
	; There could be better code here to create a potential difficulty to this by making the number in map[] a variable position so that we could have different map sizes
	mov BYTE PTR map[16], PLAYER
	
	; Ensures that the starting area surrounding the player is set to empty
	; The two lines below can also be changed by the potential update noted in line 96
	mov BYTE PTR map[17], EMPTY
	mov BYTE PTR map[31], EMPTY


;Randomly selects a valid pos for the special block
SpecialBlockPos:


	mov eax, MAP_WIDTH-2
	call RandomRange
	inc eax
	mov specialX, eax


	mov eax, MAP_HEIGHT-2
	call RandomRange
	inc eax
	mov specialY, eax


	; Avoid certain areas where the player spawns and around the player spawn
	cmp specialY, 2
	jg PlaceSpecialBlock

	
	cmp specialX, 2
	jle SpecialBlockPos


PlaceSpecialBlock:


	; Calculate map index and place the special block
	mov eax, specialY
	imul eax, MAP_WIDTH
	add eax, specialX


	mov BYTE PTR map[eax], SPECIAL_BLOCK


	pop esi
	pop edi
	pop ebx
	pop eax


	ret

GenMap ENDP


; Displays the entire map using a variety of colors for different tile types
DisplayMap PROC

	push esi
	push ebx
	push edi

	; ESI points to the start of the map array
	mov esi, OFFSET map

	; EBX tracks the number of rows remaining
	mov ebx, MAP_HEIGHT


MapR:


	; Saves the start position of the curr map row
	mov rowS, esi

	; This makes each map tile occupy two console rows (this can look weird on different consoles due to a user changing what their console looks like)
	; The default settings for a console are highly recommended to play this version of Bomberman in the best quality (that we know of :P )
	mov ecx, 2


DrawRow:
	

	; Resets ESI to the start of the curr map row
	mov esi, rowS

	; EDI tracks the number of col remaining
	mov edi, MAP_WIDTH


MapC:


	; Read the current tile
	mov dl, [esi]


	; Color selection for the right tile
	cmp dl, WALL
	je DrawWall


	cmp dl, BLOCK
	je DrawBlock


	cmp dl, PLAYER
	je DrawPlayer


	; Floor/empty space
	; https://kommodo.ai/i/6PSgOykpkPL3MA4wKhxv
	; This link is safe I promise
	mov eax, 08h
	jmp DrawTile

DrawWall:


	mov eax, 07h
	jmp DrawTile


DrawBlock:


	mov eax, 0Eh
	jmp DrawTile


DrawPlayer:


	mov eax, 0Ah
	jmp DrawTile


DrawTile:

	
	; Sets the text color
	call SetTextColor

	; Not once, not twice, not thrice, but four times
	mov al, 219
	call WriteChar
	call WriteChar
	call WriteChar
	call WriteChar

	; Moves to the next map col
	inc esi
	dec edi

	jnz MapC

	; Move to the next console row
	call Crlf


	loop DrawRow


	; Moves to the next map row
	mov esi, rowS
	add esi, MAP_WIDTH

	dec ebx
	jnz MapR

	; Restores the default console colors
	mov eax, 07h
	call SetTextColor

	pop edi
	pop ebx
	pop esi


	ret


DisplayMap ENDP


; Changes the char stored at a specific map array index
PUBLIC UpdateTile


UpdateTile PROC, tileIndex:DWORD, newTile:DWORD


		; Loads the map index and the new tile char
		mov eax, tileIndex
		mov edx, newTile


		; Replaces the existing char in the map array
		mov map[eax], dl


		ret


UpdateTile ENDP


; Draws one tile and not the whole map
; This is because if we were to update the map every single time there was an action there would be too much movement and procceses 
PUBLIC DrawSingleTile


DrawSingleTile PROC, tileX:DWORD, tileY:DWORD, tileChar:DWORD


	push eax
	push edx

	; Selects the color based on the tile char
	mov eax, 08h

	
	cmp tileChar, WALL
	je TileWall


	cmp tileChar, BLOCK
	je TileBlock


	cmp tileChar, PLAYER
	je TilePlayer


	cmp tileChar, 'B'
	je TileBomb


	jmp TileDraw


TileWall:


	mov eax, 07h
	jmp TileDraw


TileBlock:


	mov eax, 0Eh
	jmp TileDraw


TilePlayer:


	mov eax, 0Ah
	jmp TileDraw


TileBomb:


	mov eax, 0Ch
	jmp TileDraw


TileDraw:


	; Applies the correct text color
	call SetTextColor


	; Calculates the console portion of the tile
	mov eax, tileX
	imul eax, 4
	mov dl, al


	mov eax, tileY
	imul eax, 2
	mov dh, al


	call GoToXY


	; Draws the first row of the tile
	mov al, 219
	call WriteChar
	call WriteChar
	call WriteChar
	call WriteChar


	; Moves down one console row
	mov eax, tileX
	imul eax, 4
	mov dl, al


	mov eax, tileY
	imul eax, 2
	inc eax
	mov dh, al

	call GoToXY


	; Draws the second row (because again we have thick tiles)
	mov al, 219
	call WriteChar
	call WriteChar
	call WriteChar
	call WriteChar


	; Restores default console color
	mov eax, 07h
	call SetTextColor


	pop edx
	pop eax


	ret 

DrawSingleTile ENDP


END