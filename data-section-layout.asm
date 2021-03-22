global _start
section .data
  a: db 0xAA     ; 1 byte
  b: db 0xBB00   ; 00 - only one byte stored; warning: byte data exceeds bounds [-w+number-overflow]
  c: dw 0xCC00   ; 2 bytes: 00, CC
  d: dw 0x00DD   ; 2 bytes: DD, 00
  e: dd 0x00EE   ; 4 bytes: EE, 00, 00, 00 (data only fills two bytes, so the remaining ones will be 00)
  f: dd 0x00FFFF ; 8 bytes: FF, FF, 00, 00, 00, 00, 00, 00 (data fills 3 bytes, remaining ones will be 00)
  ; resulting .data layout:
  ; a  b  c     d     e           f
  ; AA 00 00 CC DD 00 EE 00 00 00 FF FF 00 00 00 00 00 00 00
