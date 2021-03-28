global _start
section .data
  a: db 0x35 
section .text
_start:
  mov al, 255
  add al, 1 ; CF = 1, OF = 0
  mov al, 0 
  sub al, 1 ; CF = 1, OF = 0

  mov al, 0x80 ; al = 1000_0000, 0x80, -128 in two's complement
  sub al, 1    ; al = 0111_1111, 0x7f, +129 in two's copmlement; OF=1
  test al, al
  sub al, 0xFF ; al = 80; OF=1, CF=1

  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
