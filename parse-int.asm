global _start
section .data
  a: db '291', 0 ; ok; 2 = 0x02, 29 =  0x1d, 291 = 0x123
  b: db '000291', 0 ; ok
  c: db 'x291', 0 ; err 1 - parsing failed
  d: db '18446744073709551616', 0 ; err 2 - overflow
  e: db '18446744073709551615', 0 ; err 2 - overflow
  ok: db 'OK', 0
  failed: db 'FAILED', 0
  newline:   db 10       ; 10 in decimal, 0A in hex - ASCII for newline char
section .text
  ; If $1 is an ASCII code for digit, return the digit as an unsigned int.
  ; Experimenting with a calling convention returning two values. If the function
  ; succeeds in producing a value, rax will be the produced value, and r11b will be 0.
  ; Otherwise, rax will be 0, and r11b will hold an error code.
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
    xor r12, r12
    .next_char:
      mov dl, byte [rdi + r9] ; dl - rdx, not rdi

      ; check if string terminated
      cmp dl, 0
      je .exit_ok

      ; not terminated; check and add digit
      push rdi       ; save
      mov rdi, 0
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
      setc r12b
      cmp r12b, 1
      je .err_overflow

      mov r12b, cl  ; get last digit
      add rax, r12  ; r11 was multiplied by 10 and ends with 0; add latest digit

      ; check if overflow from addition
      setc r12b
      cmp r12b, 1
      je .err_overflow

      mov r10, rax
      inc r9

      jmp .next_char

      .err_parse:
        pop r12
        mov rax, 0
        mov r11, 1
        ret
      .err_overflow:
        pop r12
        mov rax, 0
        mov r11b, 2
        ret

      .exit_ok:
        pop r12
        mov r11, 0
        mov rax, r10
        ret
_start:

 ; test macro
 %macro test 3
   mov rdi, %1
   call parse_int
   cmp rax, %2
   jne %%fail
   cmp r11b, %3
   jne %%fail

   ; print 'ok' and a newline
   mov rax, 1    ; syscall id
   mov rdx, 2    ; how many bytes to print - for syscall
   mov rdi, 1    ; stdout
   mov rsi, ok   ; source of data
   syscall
   mov rax, 1 ; write syscall
   mov rdi, 1 ; stdout 
   lea rsi, [newline] ; addr of newline char 
   mov rdx, 1 ; count
   syscall
   jmp %%ok
   %%fail:
     ; print 'failed', and a newline
     mov rax, 1      ; syscall id
     mov rdx, 7      ; how many bytes to print - for syscall
     mov rdi, 1      ; stdout
     mov rsi, failed ; source of data
     syscall
     mov rax, 1 ; write syscall
     mov rdi, 1 ; stdout 
     lea rsi, [newline] ; addr of newline char 
     mov rdx, 1 ; count
     syscall
   %%ok:
 %endmacro

 ; a: db '291', 0 ; ok; 2 = 0x02, 29 =  0x1d, 291 = 0x123
 test a, 291, 0

 ; b: db '000291', 0 ; ok
 test b, 291, 0

 ; c: db 'x291', 0 ; err 1 - parsing failed
 test c, 0, 1

 ; d: db '18.446.744.073.709.551.616', 0 ; err 2 - overflow
 test d, 0, 2

 ; e: db '18.446.744.073.709.551.615', 0 ; ok
 test e, 18446744073709551615, 0

 mov rax, 60  ; exit syscall
 mov rdi, r11   ; exit code
 syscall
