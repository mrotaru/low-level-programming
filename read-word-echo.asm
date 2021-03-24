global _start
section .bss
  buf resb 10
section .text
  ; Read a word from stdin, terminate it with a 0 and place it at the given
  ; address. Only the first word will be read; any characters exceeding the
  ; maximum will be truncated.
  ; - $1, rdi: *buf - where to place read bytes
  ; - $2, rsi: max_count, including the NULL terminator
  ; Returns in rax:
  ; - *buf - address of the first byte where the NULL-terminated string was placed
  ; - 0, if input too big
  read_word: ; (rdi: *buf, rsi: max_count) -> *buf, or 0 if input too big
    mov r8, 0      ; current count
    mov r9, rsi    ; max count
    dec r9         ; one char will be occupied by the terminating 0
    mov r10, 0     ; 0 - no non-ws chars so far; 1 - reading; 2 - done

    ; read a char into the top of the stack, then pop it into rax
    .next_char:
      push rdi       ; save; will be clobbered by syscall
      push 0         ; top of the stack will be used to place read byte
      mov rax, 0     ; syscall id = 0 (read)
      mov rdi, 0     ; syscall $1, fd = 0 (stdin)
      mov rsi, rsp   ; syscall $2, *buf = rsp (addr where to put read byte)
      mov rdx, 1     ; syscall $3, count (how many bytes to read)
      syscall
      pop rax
      pop rdi

      ; if read character is LF or 0, exit
      cmp rax, 0x0a ; LF, Enter
      je .exit
      cmp rax, 0x00 ; NULL - Ctrl + D ⇒ exit with err
      je .err

      ; is the read character whitespace ?
      cmp rax, 0x20 ; space
      je .whitespace
      cmp rax, 0x0d ; CR
      je .whitespace
      cmp rax, 0x09 ; tab
      je .whitespace

      jmp .not_whitespace

    .whitespace:
      cmp r10, 1      ; are we in a word ?
      jne .next_char  ; not in a word ? just read the next char
      mov r10, 2      ; in a word ? end it
      jmp .next_char  ; ended the word; read next char

    .not_whitespace:
      cmp r10, 2      ; word terminated ? read next char
      je .next_char
      cmp r8, r9               ; check if we still have room
      jb .add_char_start_word  ; add char if we do; start word (r10 = 1) if not already started
      mov r10, 2               ; we get here only if r8 >= r9 ⇒ no more room
      jmp .next_char           ; there might still be whitespace in the kernel buffer

    .add_char_start_word:
      cmp r10, 1
      je .add_char
      mov r10, 1
    .add_char:
      mov byte [rdi+r8], al ; copy character into output buffer
      inc r8                ; inc number of collected characters
      jmp .next_char

    .exit:
      mov byte [rdi+r8], 0
      mov rax, rdi
      ret
    .err:
      mov rax, 0
      ret

_start:
  push 0
  mov rdi, buf     ; $1 - *buf
  mov rsi, 10      ; $2 - uint count
  call read_word

  cmp rax, 0 ; if error, just exit
  je .exit

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

  .exit:
    mov rax, 60  ; exit syscall
    mov rdi, 0   ; exit code
    syscall
