global _start
section .text
_start:
  mov rax, 0   ; count
  .loop:
    ; ... do some work ...
    inc rax      ; increment loop count
    cmp rax, 10  ; reached max ?
    jne .loop    ; exit loop
  .done:
    ; loop completed
