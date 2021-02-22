global _start

section .data
  hex_chars: db '0123456789ABCDEF'

section .text
_start:
  mov rax, 0x1122334455667788
  mov rdi, 1
  mov rdx, 1
  mov rcx, 64 ; cl = 0x40 = 0100 0000 = 64

.loop:
  ; We're going to make some changes to rax, so let's save its current value on the stack
  push rax

  ; The rax register (like most of other ones) is 64 bits long, and each hex
  ; char encodes 4 bits so we process it 4 bits at a time. We keep track of
  ; the number of remaining bits to be processed in rcx, so it goes down by 4
  ; on each iteration.
  ; rcx: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0100 0000 (0x40 = 64)
  sub rcx, 4
  ; rcx: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0011 1100 (0x3c = 60)

  ; Move the next 4 bits to the end of the register, by shifting right. We
  ; can use rcx as the number of bits to shift. On the first iteration of
  ; the loop, rcx (and therefore cl) will be 60; shifting right 60 bits
  ; leaves the first 4 bits at the end of rax. This destroys the rest of the
  ; bits, but that's OK because we've pushed the original value of rax to
  ; the stack.
  ;    :    1    1    2    2    3    3    4    4    5    5    6    6    7    7    8    8
  ; rax: 0001 0001 0010 0010 0011 0011 0100 0100 0101 0101 0110 0110 0111 0111 1000 1000
  sar rax, cl
  ; rax: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001 (0x1)

  ; Get rid of all bits except the last 4.This is not useful for the first
  ; iteration, but in the following ones there will be more bits left after
  ; shifting. For example, after shifting 52 bits (3rd iteration), rax is
  ; 0x112 - but we only want the last 4 bits:
  ; rax: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001 0001 0010 (0x0112 = 274)
  ; 0xf: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 1111 (0x000f = 15)
  ; rax: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0010 (0x0002 = 2) ⇐ result after `and rax, 0xf`
  ; On the first iteration:
  ; rax: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001 (0x1)
  ; 0xf: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 1111 (0xf = 15)
  and rax, 0xf
  ; rax: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001 (0x01)

  ; Start preparing for syscall to print. The second argument is the address
  ; of what to print. We don't start with the first argument (syscall id)
  ; because that goes into rax, and we need rax' current value. We interpret the
  ; 4 bits in rax as a number, which is used to index into the `hex_chars` array.
  ; For example, if the 4 bits are 1010, that's 10 in decimal; the 10th item in the
  ; array is the corresponding hex char for 10, 'A' - which would get printed by the
  ; 'write' syscall invoked a bit later.
  lea rsi, [hex_chars + rax]

  ; Now we can set the first param for the syscall
  mov rax, 1 

  ; Syscalls can change rcx, so let's save it's value
    push rcx

  ; inovke syscall - prints the character encoded by the current value of
  syscall

  ; restore rcx
  pop rcx

  ; restore value of rax
  pop rax

  ; check if we need to loop again (we have more bits to print)
  cmp ecx, 0
  jne .loop

  ; invoke exit syscall
  mov rax, 60
  mov rdi, 0
  syscall
