#include <stdio.h>

#define STACK_SIZE 1024

typedef struct Stack{
    int array[STACK_SIZE];
    int i;
}Stack;

void push(Stack*, int);
int pop(Stack*);

void push(Stack* stack, int e){
    (*stack).array[++(*stack).i] = e;
}

int por(Stack* stack){
    return (*stack).array[(*stack).i--];
}