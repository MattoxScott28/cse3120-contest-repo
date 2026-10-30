.386

; OPTION PROC:PRIVATE currently this raises an error when linking, we probably want them private but we will keep this commented out for now

;Board dimensions
MAP_WIDTH EQU 15
MAP_HEIGHT EQU 13

;characters for the Board
WALL EQU '#'
BLOCK EQU '0'
EMPTY EQU '.'
PLAYER EQU 'P'

;procedure protos
DisplayMap PROTO
GetMove PROTO