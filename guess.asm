; Guess the Number - Linux x86-64 NASM
; Build: nasm -f elf64 guess.asm -o guess.o && ld guess.o -o guess
; Run: ./guess

section .data
    welcome db "Guess the Number!", 10, "I'm thinking of a number from 1 to 100.", 10
    welcome_len equ $ - welcome
    prompt db "Your guess (or Ctrl+D to quit): "
    prompt_len equ $ - prompt
    too_low db "Too low! Try again.", 10
    too_low_len equ $ - too_low
    too_high db "Too high! Try again.", 10
    too_high_len equ $ - too_high
    invalid db "Please enter a whole number from 1 to 100.", 10
    invalid_len equ $ - invalid
    correct db "Correct! You guessed the number!", 10
    correct_len equ $ - correct
    goodbye db "Goodbye!", 10
    goodbye_len equ $ - goodbye

section .bss
    input_buf resb 128

section .text
    global _start

_start:
    ; Choose a classroom-game number in the range 1..100 using RDTSC.
    rdtsc
    shl rdx, 32
    or rax, rdx
    xor rdx, rdx
    mov rcx, 100
    div rcx
    inc rdx
    mov r12, rdx

    mov rsi, welcome
    mov rdx, welcome_len
    call write_stdout

.read_again:
    mov rsi, prompt
    mov rdx, prompt_len
    call write_stdout

    xor rax, rax             ; sys_read
    xor rdi, rdi             ; stdin
    mov rsi, input_buf
    mov rdx, 128
    syscall
    test rax, rax
    jle .quit                ; EOF or read error

    xor r8, r8               ; parsed value
    xor r9, r9               ; digit count
    xor r10, r10             ; buffer index
.parse:
    cmp r10, rax
    jae .parsed
    movzx r11, byte [input_buf + r10]
    cmp r11, 10
    je .parsed
    cmp r11, 13
    je .next_char
    cmp r11, '0'
    jb .bad_input
    cmp r11, '9'
    ja .bad_input
    imul r8, r8, 10
    sub r11, '0'
    add r8, r11
    inc r9
    cmp r8, 1000
    ja .bad_input
.next_char:
    inc r10
    jmp .parse

.parsed:
    test r9, r9
    jz .bad_input
    cmp r8, 1
    jb .bad_input
    cmp r8, 100
    ja .bad_input
    cmp r8, r12
    je .won
    jb .low
    mov rsi, too_high
    mov rdx, too_high_len
    call write_stdout
    jmp .read_again

.low:
    mov rsi, too_low
    mov rdx, too_low_len
    call write_stdout
    jmp .read_again

.bad_input:
    mov rsi, invalid
    mov rdx, invalid_len
    call write_stdout
    jmp .read_again

.won:
    mov rsi, correct
    mov rdx, correct_len
    call write_stdout

.quit:
    mov rsi, goodbye
    mov rdx, goodbye_len
    call write_stdout
    mov rax, 60
    xor rdi, rdi
    syscall

; RSI = message address, RDX = byte count
write_stdout:
    mov rax, 1
    mov rdi, 1
    syscall
    ret
