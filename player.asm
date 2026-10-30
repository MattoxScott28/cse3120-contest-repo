INCLUDE Irvine32.inc

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
mov al, 1
; Check if map[playerX][playerY-1] is an available space
; If true, move player to PlayerX, PlayerY - 1
; Get Player X and Y coord and set them somewhere, we will need these variables stored somehow
ret

Left:
mov al, 2
; Check if map[playerX-1][playerY] is an available space
; If true, move player to PlayerX-1, PlayerY
; Get Player X and Y coord and set them somewhere, we will need these variables stored somehow
ret

Down:
mov al, 3
; Check if map[playerX][playerY+1] is an available space
; If true, move player to PlayerX, PlayerY + 1
; Get Player X and Y coord and set them somewhere, we will need these variables stored somehow
ret

Right:
mov al, 4
; Check if map[playerX+1][playerY] is an available space
; If true, move player to PlayerX+1, PlayerY
; Get Player X and Y coord and set them somewhere, we will need these variables stored somehow
ret

Bomb:
; Once again reads char for wasd or arrow key, the player can place the bomb in any of their cardinal directions
; Does the same checks as up, down, left, right (we could possibly reuse the labels with some code rewriting?)
; Once the bomb is placed, I'm not sure whether we want it to be timed (if thats feasible) or if we want it to be reactive, once the player moves twice
ret




GetMove ENDP
