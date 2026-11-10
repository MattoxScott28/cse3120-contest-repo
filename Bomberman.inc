.386

;Board dimensions - will most likely change to a larger map size

MAP_WIDTH EQU 15
MAP_HEIGHT EQU 13

; Characters translating to tiles
WALL EQU '#'
BLOCK EQU '0'
SPECIAL_BLOCK EQU 'S'
EXIT_TILE EQU 'X'
EMPTY EQU '.'
PLAYER EQU 'P'

; Shared variables
EXTERNDEF xPos : BYTE
EXTERNDEF yPos : BYTE
EXTERNDEF map : BYTE
EXTERNDEF finish : BYTE

; Procedures used by multiple files
GenMap PROTO
DisplayMap PROTO
GetMove PROTO
UpdateTile PROTO, tileIndex:DWORD, newTile:DWORD
DrawSingleTile PROTO, tileX:DWORD, tileY:DWORD, tileChar:DWORD
ProcessTurn PROTO
