#include <stdio.h>
#include <string.h>

#define ARRAY_SIZE = 1024;

typedef struct Terceto{
    char[3] operador;
    char[34] izq;
    char[34] der;
} Terceto;

typedef struct ArrayTerceto{
    struct Terceto[ARRAY_SIZE] array;
    int indice = 0;
} ArrayTerceto;

int crearTerceto(char*, ArrayTerceto*);
int crearTerceto(char*, char*, char*,ArrayTerceto*);

int crearTerceto(char* operando, ArrayTerceto* array){
    strcopy(array->array[array->indice].der, operando);
    return array->indice++;
}

int crearTerceto(char* operador, char* izq, char* der, ArrayTerceto* array){
    strcopy(array->array[array->indice].operador, operador);
    strcopy(array->array[array->indice].izq, izq);
    strcopy(array->array[array->indice].der, der);
    return array->indice++;
}