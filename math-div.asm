global _start
section .data
section .text
_start:
  ; the instruction param size determines how many bytes will be taken as dividend
  mov ax,  0x4e9b ; 20123 (0x9b = 155)
  mov r8w, 0x03e8 ;  1000 (0xe8 = 232) - only one byte (r8b) will be taken into account
  div r8b
  ; al: 0x56, 86  (quotient)
  ; ah: 0xab, 171 (remainder)
  ; 86 * 232 = 19952 + 171 = 20123

  ; same as above, but dividing by r8w
  mov ax,  0x4e9b ; 20_123
  mov r8w, 0x03e8 ;  1_000
  div r8w
  ; rax: 20 (0x14), rdx: 123 (0x7b)

  ; same as above, but eax is much larger
  mov rdx, 0 ; if this is not cleared, result would be wrong !
  mov eax, 0xFFFF4e9b ; 4_294_921_883
  mov r8w, 0x03e8     ;         1_000
  div r8w
  ; ax: 0x0014 (20)
  ; rax: 0xffff0014   ; 4_294_901_780 (only ax was set, ffff is leftover from previous operations !)
  ; rdx: 0x7b (123)
  mov rdx, 0 ; cleanup

  ; to divide 4626 (0x1212) by 1000:
  mov rax, 0x1212 ; 4626
  mov r8w, 0x03e8 ; 1000
  div r8w
  ; rax: 4, rdx: 626 (0x272)
  mov rdx, 0 ; cleanup

  ; if we lave ax the same but set dx, the bits in dx will be the high bits of
  ; a word so 201.234 (0x31212) will be divided by 1000:
  mov rdx, 0x0003
  mov rax, 0x1212
  mov r8w, 0x03e8 ;  1000
  div r8w
  ; rax: 201 (0xc9), rdx: 234 (0xea)

  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
