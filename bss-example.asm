global _start
section .bss
  buffer: resb    64  ; reserve 64 bytes 
  words1: resw    10  ; reserve 10 words (20 bytes)
  words2 resw     20  ; looks like the ":" after the label name is optional
section .text
_start:
  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
