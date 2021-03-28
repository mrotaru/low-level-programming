global _start
section .data
section .text
_start:
  mov al, 0xFF ; 255
  mov r8b, 0xFF ; 255
  mul r8  ; multiply value in rax (al) with value in r8b

  imul r8 ; same as above, but signed
  div r8  ; divide value in ax (or dx:ax, edx:eax, rdx:rax) with value in r8; result ⇒ rax; remainder ⇒ rdx
  idiv r8 ; same as above, but signed

  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
