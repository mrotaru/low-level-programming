global _start
section .text
_start:
  mov rax, 0xFFFFFFFFFFFFFFFF

  ; the following instructions will zero out the last 2 bytes (size of ax)
  mov ax, 0
  mov ax, 0x0

  ; all the following instructions are written as 'mov 0' and will zero out all of rax
  mov eax, 0
  mov rax, 0
  mov word rax, 0x00 ; warning: register size specification ignored [-w+other]
  mov rax, 0x0000
