
//
// X0-X2 - parameters to linux function services
// X8 - linux function number
//
.include "debug.s"

.global main

.extern get_input
.extern print_machine_status
.extern get_modulo
.extern print_modulo
.extern get_decimal
.extern print_decimal

.data
// enter mmio register here
// Number of Units (1): Allocate 1 unit of memory.
// Unit Size (1): Each unit is 1 byte in size.
// Fill Value (0): Initialize each byte with the value 0.

calculator_state: 	.fill 1, 1, 0 // power off or on, off = 0, on = 1
last_operation_answer: 		.fill 1, 1, 0

modulo_answer: 	.fill 1 ,8, 0 // used to hold last operation data
modulo_a: 			.word 0
modulo_b: 			.word 0

binary_store:		.space 32
decimal_store:		.fill 1, 8, 0

temp_store:			.fill 1, 4, 0

.text
// machine must have 1 8 bit MMIO register (ie. mov x0, 0x4000000000) use ldrb (load register byte) or strb (store register byte)
// bit 0 is On/Off, 0 = off, 1 = on
// bit 2 for lock, 0 = unlocked (user can adjust position manually), 1 = locked
// bit 7:5 are used for 8 different intensity levels
//
// aarch64-linux-gnu-gcc -c calculator.s -o calculator.o
// aarch64-linux-gnu-gcc -c input.c -o input.o
// aarch64-linux-gnu-gcc -static calculator.o input.o -o calculator
// qemu-aarch64 ./calculator


main:
	
calculator_off:
	printStr "Please enter 1 to start calculator"
	printStr "Enter -1 to exit program"
	ldr x0, =temp_store
	bl get_input
	cmp w0, #1 // checks if user enter 1 to enter calculator
	beq calculator_on
	//cmp w0, #-1
	//b exit_program
	printStr "You didnt enter 1 to start calculator or -1 to exit program"
	//printStr ""
	b calculator_off

calculator_on:
	ldr x10, =calculator_state
	strb w0, [x10]
	ldr x0, =temp_store
	
	printStr "Calcuulator started"
	printStr " "
	printStr "Main Menu"
	printStr "Enter 1 to Enter a basic expression"
	printStr "Enter 2 to do basic math expression tests" //IDK THIS WHERE TO DO MATH TESTS FOR USER
	printStr "Enter 3 for more options"
	printStr "Enter 4 to print out previous resuts" // it prints all arrays
	printStr "Enter 0 to power off"
	
	bl get_input
	cmp w0, #1
	beq calc_expression
	
	cmp w0, #2
	beq math_test
	
	cmp w0, #3
	beq extra_math_expressions
	
	cmp w0, #0
	beq calculator_off
	
	b ABNORMAL_OPERATION
	

extra_math_expressions:
	ldr x0, =temp_store
	
	printStr "Sub-Menu"
	printStr "Enter 1 to do Modulo ( % )"
	printStr "Enter 2 to Find Square Roots"
	printStr "Enter 3 to Convert Decimal to binary"
	printStr "Enter 4 to convert Binary to Decimal"
	printStr "Enter 5 to convert Decimal to Hex"
	printStr "Enter 6 to Convert Hex to Decimal"
	printStr "Enter 7 for Unit Conversion"
	printStr "Enter 8 to return back to main menu"
	
	bl get_input
	cmp w0, #1
	beq calc_mod
	
	cmp w0, #2
	beq calc_sqrt
	
	cmp w0, #3
	beq convert_deci_binary
	
	cmp w0, #4
	beq convert_binary_deci
	
	cmp w0, #5
	beq convert_deci_hex
	
	cmp w0, #6
	beq convert_hex_deci
	
	cmp w0, #7
	beq convert_units
	
	cmp w0, #8
	beq calculator_on
	
	b ABNORMAL_OPERATION
	
calc_expression:
	printStr "in calc expression"
	b calculator_on
	
math_test:
	printStr "In math test"
	b calculator_on

calc_mod: // mod is remainder (a mod b = a - (a/b)*b
	printStr "enter two numbers to find its modulo (remainder)"
	
	// get first num
	printStr "Enter First Number"
	ldr x0, =temp_store
	bl get_modulo
	mov w20, w0
	ldr x10, =modulo_a
	str w20, [x10]
	//mov w0, w20 // USED FOR DEBUG
	//bl print_modulo // USED FOR DEBUG
	
	// get sec num
	printStr "Enter Second Number"
	ldr x0, =temp_store
	bl get_modulo
	mov w21, w0
	ldr x11, =modulo_b
	str w21, [x11]
	//mov w0, w21 // USED FOR DEBUG
	//bl print_modulo // USED FOR DEBUG
	
	// do operation
	ldr x10, =modulo_a
	ldr w10, [x10]
	ldr x11, =modulo_b
	ldr w11, [x11]
	
	//printStr "DEBUGGG"
	cmp w11, #0 // comparing if div by 0
	beq ABNORMAL_OPERATION // CAN CHANGE TO HANDLE DIV by 0
	
	sdiv w12, w10, w11 // a / b
	mul w12, w12, w11 // (a / b) * b
	sub w0, w10, w12 // a - (a / b) * b

	ldr x10, =modulo_answer
	str w0, [x10]
	bl print_modulo
	printStr ""
	b extra_math_expressions

calc_sqrt:
	printStr "in sqrt"
	b extra_math_expressions
	
convert_deci_binary:
	printStr "Enter a Decimal Number to Convert to Binary"

	
	bl print_binary
	b extra_math_expressions


convert_binary_deci:
	printStr "Enter Binary Number to Convert to Decimal"
	ldr x0, =decimal_store
	mov w22, #0
	strb w22, [x0]
	
	ldr x0, =temp_store
	bl get_decimal
	
	mov w5, #1 // base
	mov w2, #2 // used to multiply by 2
	mov w6, w0 // w6 = w0, temp = input // a
	mov w7, #10 // b
convert_loop: // a - (a / b) * b
	sdiv w8, w6, w7 // (a / b)
	mul w8, w8, w7 // (a / b) * b
	sub w8, w6, w8 // w8 holds last digit a - (a / b) * b
	
	ldr x0, =decimal_store
	ldr w10, [x0]
	mul w8, w8, w5 // last digit * base
	add w10, w8, w10 // decimal += last digit * base
	
	ldr x0, =decimal_store
	strb w10, [x0]
	
	//printStr "BUGGGGGGG" 
	mul w5, w5, w2
	sdiv w6, w6, w7
	cmp w6, #0
	bne convert_loop
	
	ldr x0, =decimal_store
	ldr w0, [x0]
	bl print_decimal
	
	b extra_math_expressions

convert_deci_hex:
	printStr "in convert deci to hex"
	b extra_math_expressions
	
convert_hex_deci:
	printStr "in hex to deci"
	b extra_math_expressions
	
convert_units:
	printStr "in convert units"
	b extra_math_expressions

ABNORMAL_OPERATION:
	printStr "cALCULATOR FAULT"
	printStr "EXITING NOW"
      
exit_program:
	printStr "exiting program"

exit:        
// Setup the parameters to exit the program
// and then call Linux to do it.
        mov     X0, #0      // Use 0 return code
        mov     X8, #93     // Service command code 93 terminates this program
        svc     0           // Call linux to terminate the program
