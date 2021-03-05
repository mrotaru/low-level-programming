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
section .data
  foo: db 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
  bar: db 0x0102030405060708
  baz: dq 0x0102030405060708
section .text
_start:
  mov rdi, [foo]
  call print_hex ; ⇒ 0807060504030201 - reverse order, because little endian
  call print_newline

  mov rdi, [bar]
  call print_hex ; ⇒ 0203040506070808 - only the last byte, 08, was taken because bar is 'db' - the rest come from foo
  call print_newline

  mov rdi, [baz]
  call print_hex ; ⇒ 0102030405060708 - all 8 bytes are stored, in the "correct" order because the whole value is stored as one
  call print_newline
  call exit_ok
