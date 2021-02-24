global _start
section .text
_start:

cmp 42, 43 ; scenario A - op1 < op2
;  | Bit(s) | Label| Value  | Description                      |
;  |--------+------+--------+----------------------------------|
;  |      0 | CF   |   1    | Carry Flag                       |
;  |      2 | PF   |   1    | Parity Flag                      |
;  |      4 | AF   |   1    | Auxiliary Carry Flag             |
;  |      6 | ZF   |   0    | Zero Flag                        |
;  |      7 | SF   |   1    | Sign Flag                        |
;  |      8 | TF   |   0    | Trap Flag                        |
;  |     10 | DF   |   0    | Direction Flag                   |
;  |     11 | OF   |   0    | Overflow Flag                    |

cmp 42, 41 ; scenario B - op1 > op2
;  | Bit(s) | Label| Value  | Description                      |
;  |--------+------+--------+----------------------------------|
;  |      0 | CF   |   0    | Carry Flag                       |
;  |      2 | PF   |   0    | Parity Flag                      |
;  |      4 | AF   |   0    | Auxiliary Carry Flag             |
;  |      6 | ZF   |   0    | Zero Flag                        |
;  |      7 | SF   |   0    | Sign Flag                        |
;  |      8 | TF   |   0    | Trap Flag                        |
;  |     10 | DF   |   0    | Direction Flag                   |
;  |     11 | OF   |   0    | Overflow Flag                    |

cmp 42, 42 ; scenario C - op1 = op2
;  | Bit(s) | Label| Value  | Description                      |
;  |--------+------+--------+----------------------------------|
;  |      0 | CF   |   0    | Carry Flag                       |
;  |      2 | PF   |   1    | Parity Flag                      |
;  |      4 | AF   |   0    | Auxiliary Carry Flag             |
;  |      6 | ZF   |   1    | Zero Flag                        |
;  |      7 | SF   |   0    | Sign Flag                        |
;  |      8 | TF   |   0    | Trap Flag                        |
;  |     10 | DF   |   0    | Direction Flag                   |
;  |     11 | OF   |   0    | Overflow Flag                    |
