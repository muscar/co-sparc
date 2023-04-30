.equ SYS_exit, 1
.equ SYS_write, 4

.equ STDOUT, 1

.macro syscall no
    mov \no, %g1
    t 0x6d
.endm

.macro co_yield t r
    jmpl \t, \r
    add \r, 8, \r
.endm

.register %g2, #scratch
.register %g3, #scratch
.register %g6, #scratch

    .section ".text"
    .align 4

    .global _start

_start:
    save %sp, -64, %sp

    set a, %g2
    set b, %g3

    ! jmpl %g2, %g6
    ! add %g6, 8, %g6
    co_yield %g2, %g6

    syscall SYS_exit

a:
    save %sp, -64, %sp

    mov STDOUT, %o0
    set msg_a1, %o1
    mov (end_msg_a1-msg_a1), %o2
    syscall SYS_write

    ! jmpl %g3, %g2
    ! add %g2, 8, %g2
    co_yield %g3, %g2

    mov STDOUT, %o0
    set msg_a2, %o1
    mov (end_msg_a2-msg_a2), %o2
    syscall SYS_write

    ! jmpl %g3, %g2
    ! add %g2, 8, %g2
    co_yield %g3, %g2

    mov 10, %i0
    jmpl %g6, %g0
    restore

b:
    save %sp, -64, %sp

    mov STDOUT, %o0
    set msg_b1, %o1
    mov (end_msg_b1-msg_b1), %o2
    syscall SYS_write

    ! jmpl %g2, %g3
    ! add %g3, 8, %g3
    co_yield %g2, %g3

    mov STDOUT, %o0
    set msg_b2, %o1
    mov (end_msg_b2-msg_b2), %o2
    syscall SYS_write

    mov 20, %i0
    jmpl %g2, %g0
    restore

    .section ".data"
    .align 4

msg_a1: .ascii "a1\n"
end_msg_a1:

msg_a2: .ascii "a2\n"
end_msg_a2:

msg_b1: .ascii "b1\n"
end_msg_b1:

msg_b2: .ascii "b2\n"
end_msg_b2:
