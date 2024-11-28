
#include <stdio.h>
#include <stdint.h>
#include <math.h>

//inputs two64 bit signed floating point
// velocity in m/s
// angle in positive x theta

// angle must be between 0 to pi/2 (i.e. 180)

int8_t get_input(int8_t* input){
	scanf("%hhd", input);
	printf("\n");
	return *input;
	}
	
void get_expression(char* expression){
	printf("Enter an expression (e.g. ( 6 + ( 5 * 4 ) ) / 2)");
}
/*
int8_t get_intensity(int8_t *intensity){
	*intensity = -1;
	while (*intensity < 0 || *intensity > 7){
		scanf("%hhd", intensity);
		if(*intensity < 0 || *intensity > 7){
			printf("Interger must be in range of 0, to 7");
			printf("\n");
		}
	}
    //scanf("%hhd", intensity);
    printf("\n");
    return *intensity;
}*/




void print_machine_status(int8_t value){
	printf("%d", value);
	printf("\n");
	
}
int32_t get_modulo(int32_t* input){
	scanf("%d", input);
	printf("\n");
	return *input;
}
void print_modulo(int32_t value){
	printf("Modulo value is: ");
	printf("%d", value);
	printf("\n");
}
int32_t get_decimal(int32_t* input){
	scanf("%d", input);
	printf("\n");
	return *input;
}
void print_binary(int32_t value){
	printf("Binary value is: ");
	printf("%d", value);
	printf("\n");
}
int32_t get_binary(int32_t *input){
	scanf("%d", input);
	printf("\n");
	return *input;
}
void print_decimal(int32_t value){
	printf("Decimal value is: ");
	printf("%d", value);
	printf("\n");
}
void printstuff(int8_t debug){
	printf("%d", debug);
	printf("/n");
}
