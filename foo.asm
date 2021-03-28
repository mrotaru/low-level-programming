global _start
section .data
section .text
_start:
  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
