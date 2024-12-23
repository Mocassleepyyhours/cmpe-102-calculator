//
// X0-X2 - parameters to linux function services
// X8 - linux function number
//

//update makefile "%: %.s debug.s %.c aarch64-linux-gnu-gcc $(CFLAGS) $^ -o $@" under "all: $(TARGETS)"

.include "debug.s"
.global main

.data
	calculator_state: 	.fill 1, 1, 0 // power off or on, off = 0, on = 1
	last_operation_answer: 		.fill 1, 1, 0
	modulo_answer: 	.fill 1 ,8, 0 // used to hold last operation data
	modulo_a: 			.word 0
	modulo_b: 			.word 0
	binary_store:		.space 32
	decimal_store:		.fill 1, 8, 0
	temp_store:			.fill 1, 4, 0
	factorial_store:	.fill 1, 8, 0
	num:				.double 0.0	
	prev_result:		.skip 8//double 0.0
	deci_binary_store:  .fill 20, 4, 0
	Cm_to_m_result:		.fill 1, 8, 0
	conversion100: 		.double 100.0
	M_to_cm_result: 	.fill 1, 8, 0
	M_to_km_result:		.fill 1, 8, 0
	conversion1000: 	.double 1000.0
	km_to_m_result: 	.fill 1,8, 0



	//Weight Conversion 
	Mg_to_G_result:		.fill 1, 8, 0
	G_to_Mg_result: 	.fill 1, 8, 0
	G_to_Kg_result:		.fill 1, 8, 0
	Kg_to_G_result:		.fill 1, 8, 0
	Kg_to_Lb_result:	.fill 1, 8, 0
	kg_to_lb_factor:	.double 2.204623

.text

main: 
		//stp lr, x5, [sp, #-16]
		//ldp lr, x5, [sp], #16		
calculator_off:
	printStr "Please enter 1 to start calculator"
	printStr "Enter -1 to turn off"
	ldr x0, =temp_store
	bl get_input
	
	cmp w0, #1 // checks if user enter 1 to enter calculator
	beq main_menu
	cmp w0, #-1
	beq exit_program
	
	printStr "You didnt enter 1 to start calculator or -1 to exit program"
	//printStr ""
	b calculator_off

main_menu:	
	printStr "Calculator started"
	printStr " "
	
calculator_on:	
	printStr "Main Menu"
	printStr "Enter 1 to type a basic expression"
	printStr "Enter 2 to do basic arithmetic operations" 
	printStr "Enter 3 for more options (go to sub-menu)"
	printStr "Enter 4 to print out previous resuts" // it prints all arrays
	printStr "Enter 0 to Power Off"
	ldr x10, =calculator_state
	strb w0, [x10]
	
	ldr x0, =temp_store
	bl get_input
	
	cmp w0, #1
	beq calc_expression
	
	cmp w0, #2
	beq basic_arithmetic
	
	cmp w0, #3
	beq sub_menu
	
	cmp w0, #4
	beq result_history
	
	cmp w0, #0
	beq exit_program
	
	printStr "Invalid input."
	b calculator_on

	
calc_expression:
	printStr "In calc expression"
	b calculator_on

	
basic_arithmetic:
				//start enter 2 numbers
first_num:
	ldr x0, =num
	printStr "Enter first number: "			//data type double
	bl get_num
	
	ldr x1, =num
	str d0, [x1]
	
	fmov d3, d0
	
	sub sp, sp, #16
	str d0, [sp]
	
second_num:	
	ldr x0, =num
	printStr "Enter second number: "
	bl get_num
	
	ldr x2, =num
	str d0, [x2]
	fmov d4, d0
	
	sub sp, sp, #16
	str d0, [sp]
	
	ldr d4, [sp]
	add sp, sp, #16
	ldr d3, [sp]

operations:	
	stp d3, d4, [sp, #-16]!
		
	ldr x0, =temp_store
	printStr "Enter 1 to do Addition"
	printStr "Enter 2 to do Subtraction"
	printStr "Enter 3 to do Multiplication"
	printStr "Enter 4 to do Division"
	printStr "Enter 0 to go back Main Menu"	
	bl get_input
	
	ldr x2, =temp_store
	str x0, [x2]
	
	ldp d3, d4, [sp], #16
	
	cmp x0, 0
	beq calculator_on
	
	cmp x0, 1
	beq addition
	
	cmp x0, 2
	beq subtraction
	
	cmp x0, 3
	beq multiplication
	
	cmp x0, 4
	beq division
	
	printStr "Invalid input"
	b basic_arithmetic
	
addition:
	fadd d0, d3, d4	
	stp d3, d4, [sp, #-16]! 
	ldr x18, =prev_result
	str d0,[x18]	
	bl print

	b next

subtraction:
	fsub d0, d3, d4	
	stp d3, d4, [sp, #-16]! 
	ldr x18, =prev_result
	str d0,[x18]	
	bl print

	b next

multiplication:
	fmul d0, d3, d4	
	stp d3, d4, [sp, #-16]! 
	ldr x18, =prev_result
	str d0,[x18]	
	bl print

	b next

division:
	fcmp d4, 0
	beq undefined
	
	fdiv d0, d3, d4	
	stp d3, d4, [sp, #-16]! 
	ldr x18, =prev_result
	str d0,[x18]	
	bl print

	b next

	
undefined:
	stp d3, d4, [sp, #-16]! 
	printStr "Undefined. Divisor must be not equal to 0"
	b next
	
next:	
	
	ldr x0, =temp_store
	printStr "\nEnter 1 to continue using same numbers for other operations"
	printStr "Enter 2 to input new numbers/ back to operations menu"
	printStr "Any number to go back to Main Menu"
	bl get_input
	
	ldr x2, =temp_store
	str x0, [x2]
	ldp d3, d4, [sp], #16
	
	cmp x0, #1
	beq operations
	
	cmp x0, #2
	beq basic_arithmetic
	
	b calculator_on
	
	
sub_menu:
	ldr x0, =temp_store
	
	printStr "Sub-Menu"
	printStr "Enter 1 to do Modulo ( % )"
	printStr "Enter 2 to find Square Roots"
	printStr "Enter 3 to convert Decimal to binary"
	printStr "Enter 4 to convert Binary to Decimal"
	printStr "Enter 5 to convert Decimal to Hex"
	printStr "Enter 6 to convert Hex to Decimal"
	printStr "Enter 7 for Unit Conversion"
	printStr "Enter 8 to find value of Exponent numbers"
	printStr "Enter 9 to find Factorial"
	printStr "Any number to return back to Main Menu"
	
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
	beq exponent
	
	cmp w0, #9
	beq factorial
	
	b calculator_on
	
	//b ABNORMAL_OPERATION
	
	
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
	b sub_menu

	
calc_sqrt:
	ldr x0, =num
	printStr "Enter a number for a square root: "
	bl get_num
	
	ldr x1, =num
	str d0, [x1]
	fcmp d0, 0
	blt error
	
	fmov d5, d0
	fsqrt d0, d5
	bl print
	sub sp, sp, #16
	str d0, [sp]
	b sub_menu
	
error:
	printStr "Error: Input must be positive."
	b calc_sqrt

	
convert_deci_binary: // NOT FINISHED NEED FINISHING
	printStr "Enter a Decimal Number to Convert to Binary"
	ldr x0, =temp_store
	ldr x1, =deci_binary_store
	bl get_decimal
	// w0 holds decimal number
	mov x2, #0 // holds index of array
	mov w2, #0 // holds remainder
	
	cbz w0, store_zero
	
deci_binary_loop:
	mov w10, #2
	udiv w3, w0, w10
	msub w2, w3, w10, w0
	str w2, [x1, x2, lsl #2]
	add x2, x2, #1
	mov w0, w3
	cbnz w0, deci_binary_loop	
	
	b sub_menu
	
store_zero:
	printStr "IN ZERO"
	mov w2, #0
	//str w0, [x1, x2, lsl #2] // SOMETHING BROKEN HERE
	// bl print_binary
	b sub_menu
	
deci_binary_print:

	
convert_binary_deci:
	printStr "Enter Binary Number to Convert to Decimal"
	ldr x0, =decimal_store
	mov x22, #0
	str x22, [x0]
	
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
	ldr x10, [x0]
	mul x8, x8, x5 // last digit * base
	add x10, x8, x10 // decimal += last digit * base
	
	ldr x0, =decimal_store
	str x10, [x0]
	
	//printStr "BUGGGGGGG" 
	mul w5, w5, w2
	sdiv w6, w6, w7
	cmp w6, #0
	bne convert_loop
	
	ldr x0, =decimal_store
	ldr w0, [x0]
	bl print_decimal
	
	b sub_menu
	
	
convert_deci_hex:
    printStr "Enter a Decimal Number to Convert to Hexadecimal"
    ldr x0, =temp_store      
    bl get_decimal
	bl decimal_to_hex
	
	b sub_menu                   

decimal_to_hex:
    // x0 contains the decimal number
    // The result will be returned in x0
    mov x1, x0  // Copy input to x1
    mov x0, #0  // Initialize result to 0
    mov x2, #0  // Digit counter

hex_loop:
    cbz x1, reverse_hex  // If x1 is zero, we're done converting
    and x3, x1, #0xF  // Get least significant 4 bits
    lsl x0, x0, #4    // Shift result left by 4
    orr x0, x0, x3    // Add new digit to result
    lsr x1, x1, #4    // Shift input right by 4
    add x2, x2, #1    // Increment digit counter
    cmp x2, #16       // Check if we've processed 16 digits (64 bits)
    b.lt hex_loop

reverse_hex:
    mov x1, x0  // Copy result to x1
    mov x0, #0  // Clear x0 for reversed result
    mov x2, #0  // Reset digit counter

reverse_loop:
    cbz x1, hex_done  // If x1 is zero, we're done reversing
    and x3, x1, #0xF  // Get least significant 4 bits
    lsl x0, x0, #4    // Shift reversed result left by 4
    orr x0, x0, x3    // Add digit to reversed result
    lsr x1, x1, #4    // Shift original result right by 4
    add x2, x2, #1    // Increment digit counter
    cmp x2, #16       // Check if we've processed 16 digits
    b.lt reverse_loop

hex_done:
	bl print_hexadecimal
	b sub_menu
	
convert_hex_deci:
    printStr "Enter a Hexadecimal Number to Convert to Decimal"
    ldr x0, =temp_store        
    bl get_hexadecimal         

    printStr "DEBUG: Hexadecimal input received\n"

    // Call the C function to print the decimal value
    mov w0, w0                 
    bl print_decimal           

    b sub_menu  
	
	
convert_units:
	ldr x0, =temp_store
	printStr "Unit Conversion"
	printStr "Enter 1 for Length conversion"
	printStr "Enter 2 for Weight conversion" 
	printStr "Any number to back to Sub menu"
	bl get_input
	
	cmp w0, #1
	beq length_conversion
	
	cmp w0, #2
	beq weight_conversion
	
	b sub_menu

length_conversion:
	ldr x0, =temp_store
	printStr "Enter 1 for Centimeter to Meter"
	printStr "Enter 2 for Meter to Centimeter"
	printStr "Enter 3 for Meter to Kilometer"
	printStr "Enter 4 for Kilometer to Meter"
	printStr "Enter 5 to return to Unit Conversion menu"
	printStr "Enter 6 to return to Sub menu"
	printStr "Any number to return to Main menu"
	
	bl get_input
	
	cmp w0, #1
	beq Cm_to_M
	
	cmp w0, #2
	beq M_to_Cm
	
	cmp w0, #3
	beq M_to_Km
	
	cmp w0, #4
	beq Km_to_M
	
	cmp w0, #5
	beq convert_units
	
	cmp w0, #6
	beq sub_menu
	
	b calculator_on
	
Cm_to_M: //conversion100
	printStr "Enter Centimeter to convert to Meter"
	ldr x0, =Cm_to_m_result
	bl get_num_unit
	ldr x5, =conversion100 // #100
	ldr d5, [x5]
	fdiv d0, d0, d5 // holds value
	str d0, [x0]
	ldr x0, =Cm_to_m_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_cm_to_m
	
	b length_conversion
	
M_to_Cm:
	printStr "Enter Meter to convert to Centimeter"
	ldr x0, =M_to_cm_result
	bl get_num_unit
	ldr x5, =conversion100
	ldr d5, [x5]
	fmul d0, d0, d5
	str d0, [x0]
	ldr x0, =M_to_cm_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_m_to_cm
	
	b length_conversion
M_to_Km:
	printStr "Enter Meter to convert to Kilometer"
	ldr x0, =M_to_km_result
	bl get_num_unit
	ldr x5, =conversion1000 // #1000
	ldr d5, [x5]
	fdiv d0, d0, d5
	str d0, [x0]
	ldr x0, =M_to_km_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_m_to_km
	
	b length_conversion
	
Km_to_M:
	printStr "Enter Kilometer to convert to Meter"
	ldr x0, =km_to_m_result
	bl get_num_unit
	ldr x5, =conversion1000
	ldr d5, [x5]
	fmul d0, d0, d5
	str d0, [x0]
	ldr x0, =km_to_m_result
	ldr d0, [x0] 
	ldr x18, =prev_result
	str d0,[x18]
	bl print_km_to_m
	
	b length_conversion

weight_conversion:
	ldr x0, =temp_store
	printStr "Enter 1 for Milligram to Gram"
	printStr "Enter 2 for Gram to Milligram"
	printStr "Enter 3 for Gram to Kilogram"
	printStr "Enter 4 for Kilogram to Gram"
	printStr "Enter 5 for Kilogram to Pound"
	printStr "Enter 6 to return to Unit Conversion menu"
	printStr "Enter 7 to return to Sub menu"
	printStr "Any number to return to Main menu"
	bl get_input

	cmp w0, #1
	beq Mg_to_G

	cmp w0, #2
	beq G_to_Mg

	cmp w0, #3
	beq G_to_Kg

	cmp w0, #4
	beq Kg_to_G

	cmp w0, #5
	beq Kg_to_Lb

	cmp w0, #6
	beq convert_units
		
	cmp w0, #7
	beq sub_menu
	
	b calculator_on

Mg_to_G:
	printStr "Enter Milligram(s) to convert to Gram(s)"
	ldr x0, =Mg_to_G_result
	bl get_num_unit
	ldr x5, =conversion1000
	ldr d5, [x5]
	fdiv d0, d0, d5
	str d0, [x0]
	ldr x0, =Mg_to_G_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_mg_to_g

	b weight_conversion

G_to_Mg:
	printStr "Enter Gram(s) to convert to Milligram(s)"
	ldr x0, =G_to_Mg_result
	bl get_num_unit
	ldr x5, =conversion1000
	ldr d5, [x5]
	fmul d0, d0, d5
	str d0, [x0]
	ldr x0, =G_to_Mg_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_g_to_mg

	b weight_conversion

G_to_Kg:
	printStr "Enter Gram(s) to convert to Kilogram(s)"
	ldr x0, =G_to_Kg_result
	bl get_num_unit
	ldr x5, =conversion1000
	ldr d5, [x5]
	fdiv d0, d0, d5
	str d0, [x0]
	ldr x0, =G_to_Kg_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_g_to_kg

	b weight_conversion

Kg_to_G:
	printStr "Enter Kilogram(s) to convert to Gram(s)"
	ldr x0, =Kg_to_G_result 	
	bl get_num_unit
	ldr x5, =conversion1000
	ldr d5, [x5]
	fmul d0, d0, d5
	str d0, [x0]
	ldr x0, =Kg_to_G_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_kg_to_g

	b weight_conversion

Kg_to_Lb:
	printStr "Enter Kilogram(s) to convert to Pound(s)"
	ldr x0, =Kg_to_Lb_result
	bl get_num_unit
	ldr x5, =kg_to_lb_factor
	ldr d5, [x5]
	fmul d0, d0, d5
	str d0, [x0]
	ldr x0, =Kg_to_Lb_result
	ldr d0, [x0]
	ldr x18, =prev_result
	str d0,[x18]
	bl print_kg_to_lb

	b weight_conversion



exponent:
	ldr x0, =num
	printStr "Enter base: "			//data type double
	bl get_num
	
	ldr x1, =num
	str d0, [x1]
	fmov d5, d0
	sub sp, sp, #16
	str d0, [sp]


	ldr x0, =num
	printStr "Enter exponent: "
	bl get_num
	
	ldr x2, =num
	str d0, [x2]
	fmov d6, d0
	
	sub sp, sp, #16
	str d0, [sp]
	
	ldr d6, [sp]
	add sp, sp, #16
	ldr d5, [sp]
	
	fmov d7, 1				//d7 stores exponential result, assign it = 1
	fmov d8, 1
	
	fcmp d6, 0
	beq special1	
	blt negative	
	
	fcmp d6, d8
	beq special2	
	
	fmov d9, 1			//d9 = 1 as d6 is positive
loop:	
	fmul d7, d7, d5 
	fsub d6, d6, d8
	fcmp d6, 0
	beq expo_result1
	
	b loop 		
	
special1:			
	fmov d0, d7
	ldr x18, =prev_result
	str d0,[x18]
	bl print
	
	b sub_menu
	
special2:
	fmov d7, d5			
	fmov d0, d7
	ldr x18, =prev_result
	str d0,[x18]
	bl print
	
	b sub_menu

negative:
	//printStr "Error: Calculator is now working with positive exponent only"
	//b exponent
	fmov d9, -1			//d9 = -1 as d6 is negative
	fabs d6, d6
	fcmp d5, 0
	beq error1
	
	b loop

error1:
	printStr "Error: exponent must be positive as base equals 0"
	b exponent

expo_result1:
	fcmp d9, d8
	bne expo_result2
	
	fmov d0, d7
	ldr x18, =prev_result
	str d0,[x18]
	bl print
	
	b sub_menu

expo_result2:
	fdiv d0, d8, d7
	ldr x18, =prev_result
	str d0,[x18]
	bl print
	
	b sub_menu
	

factorial:
    printStr "Enter a non-negative integer (<= 20) to factorialize:"
    ldr x0, =factorial_store
    bl get_unsigned_num    // Input now in x0:x1 pair
    mov x5, xzr           // Zero out x5
    subs x5, x0, #1      // x5 = x0 - 1
    mov x6, xzr          // x6 will hold upper 64 bits

factorial_loop:
    // Perform 128-bit multiplication
    umulh x7, x0, x5     // Upper 64 bits of first product
    mul x0, x0, x5       // Lower 64 bits of product
    madd x6, x6, x5, x7  // Accumulate upper bits
    
    subs x5, x5, #1      // Decrement counter
    cbnz x5, factorial_loop
    
    bl print_factorial    // Print result from x0:x6 pair
    b sub_menu


	
result_history:
	ldr x0, =prev_result
	ldr d0, [x0]
	bl history
	b calculator_on
	
	
ABNORMAL_OPERATION:
	printStr "CALCULATOR FAULT"
	//printStr "TURNING OFF NOW"
	b calculator_on
 
      
exit_program:
	printStr "Turning calculator off.."
	printStr "Calculator is OFF"
exit:        
// Setup the parameters to exit the program
// and then call Linux to do it.
        mov     X0, #0      // Use 0 return code
        mov     X8, #93     // Service command code 93 terminates this program
        svc     0           // Call linux to terminate the program
