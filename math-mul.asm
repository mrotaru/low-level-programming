global _start
section .data
section .text
_start:
  mov al,  0xFF ; 255
  mov r8b, 0xFF ; 255
  mul r8  ; multiply value in rax (al) with value in r8b -> 65025, 0xFE01
  ; ax: 0xfe01, CF=0, OF=0

  mov ax,  0xFFFF  ; 65535
  mov r8,  0xFFFFF ; 1048575 (will be assembled to r8d)
  mul r8b  ; 65535 * 1048575 = 68718362625 (0xfffef0001) - but, because r8b is 1 byte, 255 * 255 = 0xfe01 
  ; eax: 0xfe01, CF=1, OF=1

  ; same as above - but multiplying by r8w instead of r8
  mov ax,  0xFFFF  ; 65535
  mov r8,  0xFFFFF ; 1048575
  mul r8w  ; 68718362625 0xfffef0001 - using two registers
  ; dx: 0xfffef, ax: 0001, CF=1, OF=1

  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
