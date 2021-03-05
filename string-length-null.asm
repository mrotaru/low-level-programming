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
  foo: db "foobar", 0
  bar: db "abc", 0
section .text

; Calculate the length of a null-terminated string
; $1/rdi: pointer (address) to string start
; returns/rax: string length
str_len:
  mov rsi, 0 ; init len 0
  .loop:
    mov dl, byte [rdi + rsi]
    cmp dl, 0
    je .end
    inc rsi
    jmp .loop
  .end:
    mov rax, rsi
    ret

_start:
  ; calc foo's length
  mov rdi, foo
  call str_len
  mov rdi, rax
  call print_hex
  call print_newline

  ; calc bar's length
  mov rdi, bar
  call str_len
  mov rdi, rax
  call print_hex
  call print_newline

  ; exit
  call exit_ok
