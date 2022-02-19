#define ARRAY_SIZE 1024

typedef struct Terceto{
    char operador[3];
    char izq[34];
    char der[34];
}Terceto;

typedef struct ArrayTerceto{
    struct Terceto array[ARRAY_SIZE];
    int indice;
}ArrayTerceto;

int crearTerceto(char*, char*, char*, ArrayTerceto*);

int crearTerceto(char* operador, char* izq, char* der, ArrayTerceto* array){
    strcpy(array->array[array->indice].operador, operador);
    strcpy(array->array[array->indice].izq, izq);
    strcpy(array->array[array->indice].der, der);
    return array->indice++;
}