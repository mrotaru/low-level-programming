global _start
section .data
  foo: db '123456789'
section .text
_start:
   mov rax, foo       ; load address of ~foo~ into rax
   mov rax, [foo]     ; load contents of ~foo~ (first 8 bytes) into rax
   ;lea rax, foo       ; error: invalid combination of opcode and operands
   lea rax, [foo]     ; load address of ~foo~ into rax
   lea rax, [foo + 1] ; load address of (~foo~ + 1) into rax
   mov rax, [foo + 1] ; load contents of (~foo~ + 1) into rax
