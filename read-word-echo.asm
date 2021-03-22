global _start
section .bss
  buf resb 10
section .text
  ; Read a word from stdin, terminate it with a 0 and place it at the given address.
  ; - $1, rdi: *buf - where to place read bytes
  ; - $2, rsi: max_count, including the NULL terminator
  ; Returns in rax:
  ; - *buf - address of the first byte where the NULL-terminated string was placed
  ; - 0, if input too big
  read_word: ; (rdi: *buf, rsi: max_count) -> *buf, or 0 if input too big
    mov r8, 0      ; current count
    mov r9, rsi    ; max count
    dec r9         ; one char will be occupied by the terminating 0

    ; read a char into the top of the stack, then pop it into rax
    .read_char:
      push rdi       ; save; will be clobbered by syscall
      mov rax, 0     ; syscall id = 0 (read)
      mov rdi, 0     ; syscall $1, fd = 0 (stdin)
      push 0         ; top of the stack will be used to place read byte
      mov rsi, rsp   ; syscall $2, *buf = rsp (addr where to put read byte)
      mov rdx, 1     ; syscall $3, count (how many bytes to read)
      syscall
      pop rax
      pop rdi

    ; if read character is Enter (aka carriage-return, CR) - null-terminate the string and exit
    cmp rax, 0x0a ; Enter
    je .exit_ok

    ; not enter ⇒ place it in the buffer, and read another one
    mov byte [rdi+r8], al ; copy character into output buffer
    inc r8                ; inc number of collected characters
    cmp r8, r9            ; make sure number doesn't exceed maximum
    je .exit_ok           ; if we have the required number of chars, exit
    jb .read_char         ; if it's not greater, read another char

    .exit_ok: ; add a null to the end of the string and return address of buffer (same as input)
      add r8, 1
      mov byte [rdi+r8], 0
      mov rax, rdi
      ret

    .exit_err: ; return 0 (error)
      mov rax, 0
      ret

_start:
  push 0
  mov rdi, buf     ; $1 - *buf
  mov rsi, 10      ; $2 - uint count
  call read_word

  ; print the read word
  mov rax, 1     ; syscall id
  mov rdx, 10    ; how many bytes to print - for syscall
  mov rdi, 1     ; stdout
  mov rsi, buf   ; source of data
  syscall

  ; print newline
  push 0x0a
  mov rax, 1     ; syscall id
  mov rdx, 1     ; how many bytes to print - for syscall
  mov rdi, 1     ; stdout
  mov rsi, rsp   ; source of data
  syscall
  pop rax

  mov rax, 60  ; exit syscall
  mov rdi, 0   ; exit code
  syscall
