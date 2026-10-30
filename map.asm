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

DisplayMap PROC

push esi
push ebx
push edi

