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
	printf("Result is: %.3lf", a);
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
		printf("Result is: %lf Centimeter", value);
		printf("\n");
		return;
}

void print_m_to_km(double value){
		printf("Result is: %lf Kilometer", value);
		printf("\n");
		return;
}

void print_km_to_m(double value){
		printf("Result is: %lf Meter", value);
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

