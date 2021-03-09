section .data
    newline:   db 10       ; 10 in decimal, 0A in hex - ASCII for newline char
    hex_chars: db '0123456789ABCDEF'

section .text
  print_newline: ; () -> void
    mov rax, 1 ; write syscall
    mov rdi, 1 ; stdout 
    lea rsi, [newline] ; addr of newline char 
    mov rdx, 1 ; count
    syscall
  ret

  print_hex: ; (rdi - number to print as hex) -> void
    mov rax, rdi
    mov rcx, 64
    .loop:
      sub rcx, 4
      push rax
      sar rax, cl
      and rax, 0xF

      push rcx    ; will be trampled by syscall
      mov rdi, 1  ; stdout
      lea rsi, [hex_chars + rax] ; addr
      mov rdx, 1  ; how many bytes to print
      mov rax, 1  ; syscall id
      syscall
      pop rcx
      pop rax
      cmp rcx, 0
      jne .loop
  ret

  exit_ok:
    mov rax, 60  ; exit syscall
    mov rdi, 0   ; exit code
    syscall
  ret

global _start
section .text
_start:
  mov rax, -5
  mov rax, -1

  ; exit
  call exit_ok
