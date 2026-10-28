INCLUDE Irvine32.inc

.data
row1 BYTE "###############",0

.code
PUBLIC DisplayBoard

DisplayBoard PROC

mov edx, OFFSET row1
#offset puts the memory address where row1 starts

call WriteString
