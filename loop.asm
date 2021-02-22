global _start

section .data
  message: db 'hello, world!', 10

section .text
_start:
  mov ecx, 0 ; loop index

.loop:
  mov rax, 1 ; store syscall number/id
  mov rdi, 1 ; syscall arg #1 - fd - stdout
  lea rsi, [message + ecx] ; syscall arg #2 - buffer address
  mov rdx, 1 ; syscall arg #3 - max nr of bytes
  push rcx
  syscall
  pop rcx

  ; compare & loop
  inc ecx ; increment loop index
  cmp ecx, 14
  jne .loop

  mov rax, 60 ; exit syscall
  mov rdi, 0  ; exit code
  syscall
