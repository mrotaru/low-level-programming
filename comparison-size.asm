global _start
section .data
  a: db 0x42
  b: db 0x4200
  c: dw 0x4200
  d: dw 0x0042
  ; resulting .data layout:
  ; 0x402000: 42 (a)
  ; 0x402001: 00 (b)
  ; 0x402002: 00 42 (c; bytes reversed)
  ; 0x402004: 42 00 (d; bytes reversed)
section .text
_start:
  mov rax, 42
  cmp rax, 42
  cmp rax, 4242 ; Z
  cmp rax, 4200 ; C
  cmp rax, [a]  ; C,Z
  cmp rax, [b]  ; C,P,S
  cmp rax, [c]  ; C,S
