global _start
section .data
  a: db '291', 0 ; 2 = 0x02, 29 =  0x1d, 291 = 0x123
section .text
  ; If $1 is an ASCII code for digit, return the digit as an unsigned int.
  ; OK: u8 (rax)
  ; Err: 0 - no error; 1 - not a digit char (r11b)
  get_digit:
    cmp dil, 48 ; 0x30 ; = '0'
    jb .err
    cmp dil, 57 ; 0x39 ; = '9'
    ja .err
    mov al, dil
    sub al, 48
    mov r11b, 0
    ret
    .err:
      mov r11b, 1
      ret

  ; Takes a null-terminated string and parses it as a 64-bit unsigned int. 
  ; Max number that can be read: 18.446.744.073.709.551.615. (18.5 bln bln)
  ; ----------------------------------------------------------------------
  ; OK: resulting number (rax)
  ; Err: 0 - no error; 1 - parsing failed, 2 - oveflow - number too big (r11b)
  ; ----------------------------------------------------------------------
  parse_int:
    mov r9, 0  ; count
    mov r10, 0 ; return value
    push r12
    .next_char:
      mov dl, byte [rdi + r9] ; dl - rdx, not rdi

      ; check if string terminated
      cmp dl, 0
      je .exit_ok

      ; not terminated; check and add digit
      push rdi       ; save
      mov dil, dl
      call get_digit
      pop rdi        ; restore
      cmp r11b, 0
      jne .err_parse

      mov cl, al    ; save digit
      mov rax, r10  ; prep multiplication of curr nr by 10
      mov r11, 10   ; multiplication factor = 10
      mul r11       ; multiply - result goes into rax

      ; check if overflow from multiply
      xor r12, r12       ; can another register/part be used ?
      setc r12b
      cmp r12b, 1
      je .err_overflow

      mov r12b, cl  ; get last digit
      add rax, r12  ; r11 was multiplied by 10 and ends with 0; add latest digit
      mov r10, rax
      inc r9

      jmp .next_char

      .err_parse:
        pop r12
        mov r11b, 1
        ret
      .err_overflow:
        pop r12
        mov r11b, 2
        ret

      .exit_ok:
        pop r12
        mov r11b, 0
        mov rax, r10
        ret
_start:
    mov rdi, a
    call parse_int

    mov rax, 60  ; exit syscall
    mov rdi, 0   ; exit code
    syscall
