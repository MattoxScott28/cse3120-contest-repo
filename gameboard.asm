INCLUDE Irvine32.inc

.data
row1 BYTE "###############",0
row2 BYTE "#P............#",0
row3 BYTE "#.#.#.#.#.#.#.#",0
row4 BYTE "#.............#",0 ;evens are =2 without P
row5 BYTE "#.#.#.#.#.#.#.#",0 ;odds are =3

; Want to make the layout grid into 15 x 13 with the walls that do not break as #, player as P, and breakable walls as 0, all other spots are .


.code
PUBLIC DisplayBoard

DisplayBoard PROC

mov edx, OFFSET row1
#offset puts the memory address where row1 starts

call WriteString
ret

DisplayBoard ENDP
