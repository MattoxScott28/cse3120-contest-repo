INCLUDE Irvine32.inc

.data
row1 BYTE "###############",0

# Want to make the layout grid into 15 x 13 with the walls that do not break as #, player as P, and breakable walls as 0


.code
PUBLIC DisplayBoard

DisplayBoard PROC

mov edx, OFFSET row1
#offset puts the memory address where row1 starts

call WriteString
ret

DisplayBoard ENDP
