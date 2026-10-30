INCLUDE Irvine32.inc
INCLUDE Bomberman.inc

.data
map BYTE (MAP_WIDTH * MAP_HEIGHT) DUP(?)


rowS DWORD ?

; Want to make the layout grid into 15 x 13 with the walls that do not break as #, player as P, and breakable walls as 0, all other spots are .

.code

DisplayMap PROC

	push esi
	push ebx
	push edi

	mov esi, OFFSET map

	mov ebx, MAP_HEIGHT

MapR:

	mov rowS, esi
	mov ecx, 2

DrawRow:
	
	mov esi, rowS
	mov edi, MAP_WIDTH

MapC:

	mov dl, [esi]

	cmp dl, WALL
	je DrawWall
	cmp dl, BLOCK
	je DrawBlock
	cmp dl, PLAYER
	je DrawPlayer

	;the floor is floor
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

	call SetTextColor

	mov al, 219
	call WriteChar
	call WriteChar
	call WriteChar
	call WriteChar

	inc esi
	dec edi

	jnz MapC

	call Crlf

	;gotta do the same for the column just fixing the rows first
	loop DrawRow

	mov esi, rowS
	add esi, MAP_WIDTH

	dec ebx
	jnz MapR

	mov eax, 07h
	call SetTextColor

	pop edi
	pop ebx
	pop esi

	ret

	DisplayMap ENDP

END

