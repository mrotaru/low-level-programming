global _start
section .text
_start:
  push 'a'   ; 1 byte
  push 'abc' ; 4 bytes
  push 100   ; 1 byte
