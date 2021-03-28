global _start
section .text
_start:
  mov rax, 0   ; count
  .loop:
    cmp rax, 10  ; reached max ?
    je .done     ; exit loop
    ; ... do some work ...
    inc rax      ; increment loop count
    jmp .loop    ; loop again
  .done:
    ; loop completed
