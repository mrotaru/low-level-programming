global _start
section .text
_start:
  mov rax, 51   ; it's >50, so we want to set rbx to 1
  cmp rax, 50   ; compare the two operands - will set dedicated register falgs
  jl .large     ; if th
