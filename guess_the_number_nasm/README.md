# Guess the Number — Linux x86-64 NASM

A small terminal game written in NASM assembly. It chooses a number from 1 to 100, reads guesses, and tells the player whether each guess is too low, too high, or correct.

## Requirements
- Linux x86-64 (or an x86-64 Linux virtual machine)
- NASM
- GNU `ld`

On Debian/Ubuntu, install NASM with `sudo apt update && sudo apt install nasm`.

## Build and run
```sh
nasm -f elf64 guess.asm -o guess.o
ld guess.o -o guess
./guess
```

Enter a whole number from 1 to 100. Press Ctrl+D to quit.

## Concepts demonstrated
- Linux `read`, `write`, and `exit` system calls
- Registers used to pass syscall arguments and hold values
- ASCII digit-to-integer conversion
- Comparisons and conditional jumps
- A loop that repeatedly reads input until the player wins or enters EOF

The secret number is derived from the CPU timestamp counter (`RDTSC`) and reduced to 1–100. This is suitable only for a simple classroom game, not security-sensitive randomness.

## Question 11 submission
Upload `guess.asm` and this README to your own GitHub repository. Then paste the real repository URL into Question 11 and make sure your tutor can access it. Do not use a placeholder URL.
