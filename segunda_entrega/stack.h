#include <stdio.h>

#define STACK_SIZE

typedef Stack{
    int[1024] array;
    int i = 0;
}

void push(Stack*, int);
int pop(Stack*);

push(Stack* stack, int e){
    stack[++i] = e;
}

push(Stack* stack, int e){
    return stack[i--];
}