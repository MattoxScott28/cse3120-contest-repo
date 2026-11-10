INCLUDE Irvine32.inc
INCLUDE Bomberman.inc

.data
myString3 BYTE "GetMove is working",0
bombX BYTE 0
bombY BYTE 0
EXTERN xPos : BYTE
EXTERN yPos : BYTE
EXTERN map : BYTE
.code
PUBLIC GetMove

GetMove PROC
  call ReadChar

  and AL, 0DFh
  
  ; Compare the key input with the W key and the Up arrow, if equal the character moves upward
  cmp al, 'W'
  je Up
  cmp ah, 48h
  je Up

  ; Compare the key input with the A key and Left arrow, if equal the character moves left
  cmp al, 'A'
  je Left
  cmp ah, 4Bh
  je Left

  ; Compare the key input with the S key and Down arrow, if equal, the character moves down
  cmp al, 'S'
  je Down
  cmp ah, 50h
  je Down

  ; Compare the key input with the D key and Right arrow, if equal, the character moves right
  cmp al, 'D'
  je Right
  cmp ah,4Dh
  je Right
  
  ;cmp al, 'E'
  ;je Bomb

  ;mov al, 0
  ;ret

  jmp Invalid

Up:

; Check if map[playerX][playerY-1] is an available space
cmp yPos, 1
je Invalid

movzx eax, yPos
dec eax
imul eax, MAP_WIDTH

movzx ebx, xPos
add eax,ebx

mov dl, map[eax] ; READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED

; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, WALL
je Invalid

cmp dl, BLOCK
je Invalid

cmp dl, 'B'
je Invalid

movzx eax, yPos
imul eax, MAP_WIDTH
movzx ebx, xPos
add eax, ebx

INVOKE UpdateTile, eax, EMPTY

dec yPos

movzx eax, yPos
imul eax, MAP_WIDTH
movzx ebx, xPos
add eax, ebx

INVOKE UpdateTile, eax, PLAYER
mov al, 1
ret


; If the player is in bomb placing mode (esi = 1), jump to BombPlaceUp
;cmp esi,1
;je BombPlaceUp

; If true, move player to PlayerX, PlayerY - 1
;sub yPos,1
;mov dl, 50h ; dl should be used to represent what is being put into the updated tile, 50 will represent a player as 50 is the hex value for capital P
; call UpdateTile ( to my understanding, map[eax] is the tile that needs to be updated, I'm not sure if eax needs to be pushed for this to work or not )
;ret

;BombPlaceUp:
;mov dl, 42h ; dl should be used to represent what is being put into the updated tile, 42h will represent a bomb as 42h is the hex value for capital B
; call UpdateTile, again uses eax, map[eax] should be the correct tile

; Store position of the bomb for future reference
;mov al, xPos
;mov bombX, al
;mov al, yPos
;mov bombY, al
;dec bombY

;mov esi,2 ; 2 indicates the player is not in bomb placing mode, but there is a bomb placed currently

;ret

Left:
; Check if map[playerX-1][playerY] is an available space
cmp xPos, 1
je Invalid

movzx eax, yPos
imul eax, MAP_WIDTH

movzx ebx, xPos
dec ebx
add eax,ebx

mov dl, map[eax] ; READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED

; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, WALL
je Invalid

cmp dl, BLOCK
je Invalid

cmp dl, 'B'
je Invalid

; remove from old position
movzx eax, yPos
imul eax, MAP_WIDTH
movzx ebx, xPos
add eax, ebx

INVOKE UpdateTile, eax, EMPTY

dec xPos

movzx eax, yPos
imul eax, MAP_WIDTH
movzx ebx, xPos
add eax, ebx

INVOKE UpdateTile, eax, PLAYER
mov al, 1
ret

; If the player is in bomb placing mode (esi = 1), jump to BombPlaceLeft
;cmp esi,1
;je BombPlaceLeft
; If true, move player to PlayerX-1, PlayerY
;sub xPos,1
;mov dl, 50h ; dl should be used to represent what is being put into the updated tile, 50h will represent a player as 50h is the hex value for capital P
; call UpdateTile ( to my understanding, map[eax] is the tile that needs to be updated, I'm not sure if eax needs to be pushed for this to work or not )

;BombPlaceLeft:
;mov dl, 42h ; dl should be used to represent what is being put into the updated tile, 42h will represent a bomb as 42h is the hex value for capital B
; call UpdateTile, again uses eax, map[eax] should be the correct tile

; Store bomb position for future reference
;mov al, xPos
;mov bombX, al
;mov al, yPos
;mov bombY, al
;dec bombX

;mov esi,2 ; 2 indicates the player is not in bomb placing mode, but there is a bomb placed currently

Down:
; Check if map[playerX][playerY+1] is an available space
cmp yPos, 11
je Invalid

movzx eax, yPos
inc eax

imul eax, 15

movzx ebx, xPos
add eax,ebx

mov dl, map[eax] ; READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED

; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, '0'
je Invalid

cmp dl, '#'
je Invalid

; If the player is in bomb placing mode (esi = 1), jump to BombPlaceDown
;cmp esi,1
;je BombPlaceDown

; If true, move player to PlayerX, PlayerY + 1
;add yPos,1
;mov dl, 50h ; dl should be used to represent what is being put into the updated tile, 50h will represent a player as 50h is the hex value for capital P
; call UpdateTile ( to my understanding, map[eax] is the tile that needs to be updated, I'm not sure if eax needs to be pushed for this to work or not )
;ret

;BombPlaceDown:
;mov dl, 42h ; dl should be used to represent what is being put into the updated tile, 42h will represent a bomb as 42h is the hex value for capital B
; call UpdateTile, again uses eax, map[eax] should be the correct tile

; Store bomb position for future reference
;mov al, xPos
;mov bombX, al
;mov al, yPos
;mov bombY, al
;inc bombY

;mov esi,2 ; 2 indicates the player is not in bomb placing mode, but there is a bomb placed currently
ret

Right:
; Check if map[playerX+1][playerY] is an available space
cmp xPos, MAP_WIDTH-2
je Invalid

movzx eax, yPos
imul eax, MAP_WIDTH

movzx ebx, xPos
inc ebx
add eax,ebx

mov dl, map[eax] ; READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED


; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, WALL
je Invalid

cmp dl, BLOCK
je Invalid

cmp dl, 'B'
je Invalid

movzx eax, yPos
imul eax, MAP_WIDTH
movzx ebx, xPos
add eax, ebx

INVOKE UpdateTile, eax, EMPTY

inc xPos

movzx eax, yPos
imul eax, MAP_WIDTH
movzx ebx, xPos
add eax, ebx

INVOKE UpdateTIle, eax, PLAYER
mov al, 1
ret

; If the player is in bomb placing mode (esi = 1), jump to BombPlaceRight
;cmp esi,1
;je BombPlaceRight

; If true, move player to PlayerX+1, PlayerY
;add xPos,1
;mov dl, 50h ; dl should be used to represent what is being put into the updated tile, 50h will represent a player as 50h is the hex value for capital P
; call UpdateTile ( to my understanding, map[eax] is the tile that needs to be updated, I'm not sure if eax needs to be pushed for this to work or not )
;ret

;BombPlaceRight:
;mov dl, 42h ; dl should be used to represent what is being put into the updated tile, 42h will represent a bomb as 42h is the hex value for capital B
; call UpdateTile, again uses eax, map[eax] should be the correct tile

; Store bomb position for future reference
;mov al, xPos
;mov bombX, al
;mov al, yPos
;mov bombY, al
;inc bombX

;mov esi,2 ; 2 indicates the player is not in bomb placing mode, but there is a bomb placed currently

;ret

Bomb:

; If there is not a bomb placed (esi=2), Set esi to 1 to indicate bomb placement mode, otherwise jump to invalid
cmp esi,2
je Invalid
mov esi, 1

; Read char, same as before but for bomb placement
call ReadChar
and AL, 0DFh

cmp al, 'W'
je Up

cmp al, 'A'
je Left

cmp al, 'S'
je Down

cmp al, 'D'
je Right


; Once again reads char for wasd or arrow key, the player can place the bomb in any of their cardinal directions
; Does the same checks as up, down, left, right (we could possibly reuse the labels with some code rewriting?)
; Once the bomb is placed, I'm not sure whether we want it to be timed (if thats feasible) or if we want it to be reactive, once the player moves twice
ret

BombExplode:

; Checks above a bomb for a breakable block, replaces it with an empty space if so
checkUp:
movzx eax, bombY
dec eax

imul eax, 15

movzx ebx, bombX
add eax,ebx

mov dl, map[eax]

cmp dl, '0'
jne checkRight
mov dl, 2Eh
; UpdateTile to replace the block with an empty space

; Checks to the right of a bomb for a breakable block, replaces it with an empty space if so
checkRight:

movzx eax, bombY
imul eax, MAP_WIDTH

movzx ebx, bombX
inc ebx

add eax,ebx

mov dl, map[eax]

cmp dl, '0'
jne checkLeft
mov dl, 2Eh
; UpdateTile to replace the block with an empty space

; Checks to the left of a bomb for a breakable block, replaces it with an empty space if so
checkLeft:

movzx eax, bombY
imul eax, 15

movzx ebx, bombX
dec ebx

add eax,ebx

mov dl, map[eax]

cmp dl,'0'
jne checkDown
mov dl, 2Eh
; UpdateTile to replace the block with an empty space

; Checks below a bomb for a breakable block, replaces it with an empty space if so
checkDown:

movzx eax, bombY
inc eax

imul eax, 15

movzx ebx, bombX
add eax,ebx

mov dl, map[eax]

cmp dl,'0'
jne removeBomb
mov dl,2Eh
; UpdateTile to replace the block with an empty space

; Replaces the bomb with an empty space
removeBomb:
movzx eax, bombY
imul eax,15

movzx ebx, bombX
add eax,ebx
mov dl,2Eh
; UpdateTile to replace the bomb with an empty space

ret

Invalid:
ret


GetMove ENDP
END
