global _start
section .data
section .text
_start:
  mov al, -1   ; al = 0xFF, 1111_1111; unsigned = 255
  mov al, -2   ; al = 0xFE, 1111_1110; unsigned = 254
  mov al, 255  ; 
  mov al, 256  ; mov al, 0 ; warning
  mov al, 257  ; mov al, 1 ; warning

  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
