org 100h ;offset for dosbox

/* variables */
score dw 0
welcomeMessage db "Hello World", 0ah, 0dh, '$'

/* code */

_start:
  mov dx, welcomeMessage
  mov ah, 09h
  int 21h

  mov ah, 4ch
  int 21h

