global _start

section .data
message: db 'goodbye, world!', 10

section .text
_start:
  mov rax, 1 ; store syscall number/id
  mov rdi, 1 ; syscall arg #1 - fd - stdout
  mov rsi, message ; syscall arg #2 - buffer address
  mov rdx, 14 ; syscall arg #3 - max nr of bytes
  syscall

  mov rax, 60 ; exit syscall
  xor rdi, rdi ; exit code
  syscall
