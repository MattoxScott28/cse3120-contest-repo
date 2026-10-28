INCLUDE Irvine32.inc

.code
PUBLIC GetMove

GetMove PROC
  call ReadChar

  and AL, 0DFh
  cmp al, 'W'
  je Up
  cmp ah, 48h
  je Up

  cmp al, 'A'
  je Left
  cmp ah, 4Bh
  je Left

  cmp al, 'S'
  je Down
  cmp ah, 50h
  je Down

  cmp al, 'D'
  je Right
  cmp ah,4Dh
  je Right

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




GetMove ENDP
