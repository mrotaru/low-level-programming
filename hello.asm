global _start

section .data
  message: db 'hello, world!', 10

section .text
_start:
  mov rax, 1 ; store syscall number/id
  mov rdi, 1 ; syscall arg #1
  mov rsi, message ; syscall arg #2
  mov rdx, 14 ; syscall arg #3
  syscall
