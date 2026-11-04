INCLUDE Irvine32.inc
INCLUDE Bomberman.inc

.data
myString3 BYTE "GetMove is working",0
EXTERN xPos : BYTE
EXTERN yPos : BYTE
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
  
  cmp al, 'E'
  je Bomb

  mov al, 0
  ret

Up:

; Check if map[playerX][playerY-1] is an available space
cmp yPos, 0
je Invalid

movzx eax, yPos
dec eax

imul eax, 15

movzx ebx, xPos
add eax,ebx

; mov dl, map[eax] READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED

; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, 'X'
je Invalid

cmp dl, 'U'
je Invalid


; If the player is in bomb placing mode (esi = 1), jump to BombPlaceUp
cmp esi, 0
;jne BombPlaceUp

; If true, move player to PlayerX, PlayerY - 1
sub yPos,1
ret

Left:
; Check if map[playerX-1][playerY] is an available space
cmp xPos, 0
je Invalid

movzx eax, yPos
imul eax, 15

movzx ebx, xPos
dec ebx

add eax,ebx

; mov dl, map[eax] READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED

; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, 'X'
je Invalid

cmp dl, 'U'
je Invalid

; If the player is in bomb placing mode (esi = 1), jump to BombPlaceLeft
cmp esi,0
;jne BombPlaceLeft
; If true, move player to PlayerX-1, PlayerY
sub xPos,1
ret

Down:
; Check if map[playerX][playerY+1] is an available space
cmp yPos, 12
je Invalid

movzx eax, yPos
inc eax

imul eax, 15

movzx ebx, xPos
add eax,ebx

; mov dl, map[eax] READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED

; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, 'X'
je Invalid

cmp dl, 'U'
je Invalid

; If the player is in bomb placing mode (esi = 1), jump to BombPlaceDown
cmp esi,0
;jne BombPlaceDown

; If true, move player to PlayerX, PlayerY + 1
add yPos,1
ret

Right:
; Check if map[playerX+1][playerY] is an available space
cmp xPos, 14
je Invalid

movzx eax, yPos
imul eax, MAP_WIDTH

movzx ebx, xPos
inc ebx

add eax,ebx

; mov dl, map[eax] READD THIS LINE ONCE MAP HAS BEEN PUBLICLY DECLARED


; If the tile the player is trying to move to is a wall or breakable block, jump to Invalid
cmp dl, 'X'
je Invalid

cmp dl, 'U'
je Invalid

; If the player is in bomb placing mode (esi = 1), jump to BombPlaceRight
cmp esi,0
;jne BombPlaceRight

; If true, move player to PlayerX+1, PlayerY
add xPos,1
ret

Bomb:

; Set esi to 1 to indicate bomb placement mode
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

Invalid:
ret


GetMove ENDP
END
