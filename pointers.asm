global _start
section .data
  foo: db 'abcdefgh'
section .text
_start:
  mov rax, foo   ; put the address of the first byte of foo into rax
  mov rax, 0     ; zero out rax
  mov ah, [foo]  ;
  mov al, [foo]  ;
  mov ax, [foo]  ; ax is 2 bytes; so starting with the first byte of foo, copy 2 bytes to ax
  mov eax, [foo] ; eax is 4 bytes; so starting with the first byte of foo, copy 4 bytes to ax
  mov rax, [foo] ; rax is 8 bytes; so starting with the first byte of foo, copy 8 bytes to ax
