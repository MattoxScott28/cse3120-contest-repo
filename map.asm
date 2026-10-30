INCLUDE Irvine32.inc
INCLUDE Bomberman.inc

.data
 map BYTE   "###############",
			"#P............#",0
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
PUBLIC DisplayBoard

DisplayBoard PROC

mov edx, OFFSET row1
#offset puts the memory address where row1 starts

call WriteString
ret

DisplayBoard ENDP
