global _start
section .data
  a: db 0xAA   ; = 170
  b: db 0xBB00 ; only 00 will be stored; a warning will be generated at compile time
  c: dw 0xCC00
  d: dw 0x00DD
  ;         a b c   d
  ; .data:  AA0000CCDD00
section .text
_start:
  mov rax, 0xAA
  ; rax:    00000000AA
  ; eax:      000000AA
  ; al:             AA
  ; ah:             00

  cmp rax, 0xAA    ; EQ
  cmp rax, [a]     ; NE - rax compared with 000000DDCC0000AA - 8 bytes (because rax is 8 bytes) starting at a, but reversed because little-endian
  ; cmp 0xDDCC0000AA, [a]     ; error: invalid combination of opcode and operands
  ; cmp [a], 0xDDCC0000AA     ; error: operation size not specified
  cmp [a], byte 0xDDCC0000AA  ; EQ; warning: byte data exceeds bounds [-w+number-overflow]
  cmp byte [a], 0xDDCC0000AA  ; EQ; warning: byte data exceeds bounds [-w+number-overflow]

  mov rcx, 0xDDCC0000AA ; EQ
  ; NOTE: mov is actually "movabs" in compiled code - https://reverseengineering.stackexchange.com/a/2628
  ; quote from http://www.ucw.cz/~hubicka/papers/amd64/node1.html:
  ; --------------------------------------------------------------
  ; The immediate operands of instructions has not been extended to 64 bits to
  ; keep instruction size smaller, instead they remain 32-bit sign extended.
  ; Additionally the movabs instruction to load arbitrary 64-bit constant into
  ; register and to load/store integer register from/to arbitrary constant
  ; 64-bit address is available.
  cmp rcx, [a]     ; EQ

  ; because 'a' is only one byte, it should be compared with other 1 byte values
  cmp al, [a]      ; EQ; in assembly, ~byte~ (as below) is automatically added
  cmp al, byte [a] ; EQ
  cmp ah, [a]      ; NE
