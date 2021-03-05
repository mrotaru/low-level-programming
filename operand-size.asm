global _start
section .data
  foo: dq 0xBEEFBABE
  bar: dq 0xDECAFBAD
section .text
_start:
  ;mov [foo], bar ; error: operation size not specified
  ;mov [foo], 1 ; error: operation size not specified
  ;mov byte[foo], bar ; ⇒ relocation truncated to fit: R_X86_64_8 against `.data'
  ;mov [foo], [bar] ; error: invalid combination of opcode and operands
  mov byte  [foo], 1 ; NOTE: bytes are stored in reverse, so this will leave foo as 0xBEEFBA01 (in memory: 0x01BAEFBE)
  mov byte  [foo], 0x8BADF00D ; warning: byte data exceeds bounds [-w+number-overflow] (only 0D - 1 byte - will be moved)
  mov word  [foo], 0x8BADF00D ; warning: word data exceeds bounds [-w+number-overflow]
  mov dword [foo], 0x8BADF00D ; 
  mov qword [foo], 0x8BADF00D ; warning: signed dword immediate exceeds bounds [-w+number-overflow], warning: dword data exceeds bounds [-w+number-overflow]
