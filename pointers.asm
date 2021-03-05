global _start
section .data
  foo: db 'aaaaaaaa' ; NOTE: ASCII code for 'a' is 96, or 0x61
section .text
_start:
  mov rax, foo   ; 00 00 00 00 00 40 20 00 ; put the address of the first byte of foo into rax
  mov rax, 0     ; 00 00 00 00 00 00 00 00 ; zero out rax
  mov ah,  [foo] ; 00 00 00 00 00 00 61 00 ; fill the "high" byte of ax with the first byte of foo
  mov al,  [foo] ; 00 00 00 00 00 00 61 61 ; fill the "low" byte of ax with the first byte of foo (note: high byte is filled from previous command)
  mov ax,  [foo] ; 00 00 00 00 00 00 61 61 ; ax is 2 bytes; so starting with the first byte of foo, copy 2 bytes to ax
  mov eax, [foo] ; 00 00 00 00 61 61 61 61 ; eax is 4 bytes; so starting with the first byte of foo, copy 4 bytes to ax
  mov rax, [foo] ; 61 61 61 61 61 61 61 61 ; rax is 8 bytes; so starting with the first byte of foo, copy 8 bytes to ax
