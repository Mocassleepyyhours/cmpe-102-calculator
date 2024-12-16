# CMPE 102 Calculator project

## TODO
- Print Previous Result
- Math expressions?
- Convert Decimal to Binary DONE
- Convert Decimal to Hex (vice versa) DONE
- ~~Factorial~~ DONE

## Build Instructions
On Ubuntu/Debian:
- aarch64-linux-gnu-gcc -g calculator.s debug.s input.c -o calculator
- qemu-aarch64 ./calculator

On Arch-based Distributions:
- aarch64-linux-gnu-gcc -g -static calculator.s debug.s input.c -o calculator
- qemu--aarch64 ./calculator
