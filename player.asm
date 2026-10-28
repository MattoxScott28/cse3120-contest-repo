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
ret

Left:
mov al, 2
ret

Down:
mov al, 3
ret

Right:
mov al, 4
ret

Bomb:
; Unsure what to do with this yet
ret




GetMove ENDP
