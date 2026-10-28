INCLUDE Irvine32.inc

.code
PUBLIC GetMove

GetMove PROC
  call ReadChar

  and AL, 0DFh
  cmp al, 'W'
  je Up

  ret

Up:
mov al, 1
ret




GetMove ENDP
