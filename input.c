#include <stdio.h>
#include <stdint.h> 
#include <stdlib.h>

int8_t get_input(int8_t* input){
	scanf("%hhd", input);
	printf("\n");
	return *input;
	}
	
void get_expression(char* expression){
	printf("Enter an expression (e.g. ( 6 + ( 5 * 4 ) ) / 2)");
}

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

double get_num(double* num)
{
	scanf("%lf", num);
	return *num;
}

void print(double a)
{
	printf("Result is: %.3lf\n", a);
	return;
}

double get_num_unit(double *value) {
	scanf("%lf", value);
	printf("\n");
	return *value;	
}

void print_cm_to_m(double value){
		printf("Result is: %lf Meters", value);
		printf("\n");
		return;
}

void print_m_to_cm(double value){
		printf("Result is: %lf Centimeters", value);
		printf("\n");
		return;
}

void print_m_to_km(double value){
		printf("Result is: %lf Kilometers", value);
		printf("\n");
		return;
}

void print_km_to_m(double value){
		printf("Result is: %lf Meters", value);
		printf("\n");
		return;
}


//Weight Conversion

void print_mg_to_g(double value) {
	printf("Result is: %lf Grams", value);
	printf("\n");
	return;
}

void print_g_to_mg(double value) {
	printf("Result is: %lf Milligrams", value);
	printf("\n");
	return;
}

void print_g_to_kg(double value){
	printf("Result is: %lf Kilograms", value);
	printf("\n");
	return;
}

void print_kg_to_g(double value){
	printf("Result is: %lf Grams", value);
	printf("\n");
	return;
}

void print_kg_to_lb(double value){
	printf("Result is: %lf Pounds", value);
	printf("\n");
	return;
}

//Factorial
__uint128_t get_unsigned_num(__uint128_t* input) {
    // Use single 64-bit read since we only need numbers up to 20!
    uint64_t num;
    scanf("%lu", &num);  // Read single 64-bit value
    *input = (__uint128_t)num;
    printf("\n");
    return *input;
}

void print_factorial(__uint128_t value) {
    if (value <= UINT64_MAX) {
        printf("Factorial is: %lu\n", (uint64_t)value);
    } else {
        // For larger values, print in scientific notation
        double scientific = (double)value;
        printf("Factorial is: %.2e\n", scientific);
    }
}

void print_hexadecimal(int32_t decimal) {
    printf("Hexadecimal value is: %X\n", decimal);  
}

int32_t get_hexadecimal() {
    int32_t value;
    printf("Enter a Hexadecimal Number: ");
    scanf("%X", &value);  
    return value;
}
