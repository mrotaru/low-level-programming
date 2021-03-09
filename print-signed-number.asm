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
  foo: dq 0xffffffffffffffff
  bar: dq 0xfffffffffffffffc
  baz: dq 0x5

section .text

; Print the input buffer as a 64-bit unsigned int
; $1/rdi: pointer (address) to first byte
print_uint:
  mov rcx, 10
  mov rax, [rdi]
  mov r8, 0      ; counts number of digits
  .loop:
    inc r8
    mov rdx, 0   ; used by div as the high word
    div rcx      ; division result ⇒ rax; remainder ⇒ rdx
    add rdx, 48  ; add 48 to get ascii code
    push rdx
    cmp rax, 0
    jne .loop

  mov rax, 1     ; syscall id
  mov rdx, 1     ; how many bytes to print - for syscall
  mov rdi, 1     ; stdout
  .print_loop:
    mov rsi, rsp   ; top of stack - ASCII code of decimal digit
    syscall
    pop r9
    dec r8
    cmp r8, 0
    jne .print_loop

  ret

; Print the input buffer as a 64-bit signed int, represented as two's complement
; $1/rdi: pointer (address) to first byte
print_int:
  ; get ascii for the sign (+: 43, -: 45)
  mov r8, 43     ; assume positive
  mov r9, [rdi]  ; copy the number
  sar r9, 63     ; shift 63 bits out
  cmp r9, 0      ; 0 - positive
  je .set_pos
  jne .set_neg
  .set_neg:
  mov r8, 45     ; - (minus)
  ; get the unsigned value
  mov r9, [rdi]
  not r9         ; invert all bits
  add r9, 1      ; add 1
  jmp .print_sign
  .set_pos:
  mov r9, [rdi]

  ; print the sign
  .print_sign:
  mov rax, 1     ; syscall id
  mov rdx, 1     ; how many bytes to print - for syscall
  mov rdi, 1     ; stdout
  push r8
  mov rsi, rsp   ; what to print - ascii of sign
  syscall
  pop r8

  ; use previously defined function to print the number
  push r9
  mov rdi, rsp
  call print_uint
  pop r9
  ret

  _start:
    ; print -1
    mov rdi, foo
    call print_int
    call print_newline

    ; print -5
    mov rdi, bar
    call print_int
    call print_newline

    ; print 5
    mov rdi, baz
    call print_int
    call print_newline

    ; exit
    call exit_ok
