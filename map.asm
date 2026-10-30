INCLUDE Irvine32.inc
INCLUDE Bomberman.inc

.data
 map BYTE   "###############",
			"#P............#",
			"#.#.#.#.#.#.#.#",
			"#.............#",
			"#.#.#.#.#.#.#.#",
			"#.............#", 
			"#.#.#.#.#.#.#.#", 
			"#.............#", 
			"#.#.#.#.#.#.#.#", 
			"#.............#", 
			"#.#.#.#.#.#.#.#", 
			"#.............#", 
			"###############",0

; Want to make the layout grid into 15 x 13 with the walls that do not break as #, player as P, and breakable walls as 0, all other spots are .

.code

DisplayMap PROC

	push esi
	push ebx
	push edi

	mov esi, OFFSET map

	mov ebx, MAP_HEIGHT

MapR:

	mov edi, MAP_WIDTH

MapC:

	mov dl, [esi]

	cmp dl, WALL
	cmp dl, BLOCK
	cmp dl, PLAYER
	;this be a tile then

	inc esi
	dec edi

	jnz MapC

	call Crlf

	dec ebx
	jnz MapR

	pop edi
	pop ebx
	pop esi

	ret

	DisplayMap ENDP

END

