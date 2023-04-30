.equ SYS_exit, 1
.equ SYS_write, 4

.equ STDOUT, 1

.macro syscall no
    mov \no, %g1
    t 0x6d
.endm

.macro co_init l r
    set \l, \r
.endm

.macro co_yield t r
    jmpl \t, \r
    add \r, 8, \r
.endm

.macro co_done t r
    jmpl \t, \r
    restore
.endm

.register %g2, #scratch
.register %g3, #scratch
.register %g6, #scratch

#define co_main %g6
#define co_a %g2
#define co_b %g3

    .section ".text"
    .align 4

    .global _start

_start:
    save %sp, -64, %sp

    co_init a, co_a
    co_init b, co_b

    co_yield co_a, co_main

    syscall SYS_exit

a:
    save %sp, -64, %sp

    mov STDOUT, %o0
    set msg_a1, %o1
    mov (end_msg_a1-msg_a1), %o2
    syscall SYS_write

    co_yield co_b, co_a

    mov STDOUT, %o0
    set msg_a2, %o1
    mov (end_msg_a2-msg_a2), %o2
    syscall SYS_write

    co_yield co_b, co_a

    mov 10, %i0
    co_done co_main, co_a

b:
    save %sp, -64, %sp

    mov STDOUT, %o0
    set msg_b1, %o1
    mov (end_msg_b1-msg_b1), %o2
    syscall SYS_write

    co_yield co_a, co_b

    mov STDOUT, %o0
    set msg_b2, %o1
    mov (end_msg_b2-msg_b2), %o2
    syscall SYS_write

    mov 20, %i0
    co_done co_a, co_b

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
