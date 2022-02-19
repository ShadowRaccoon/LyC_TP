 %{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"


struct struct_tablaSimbolos
{
	char nombre[100];
	char tipo[100];
	char valor[50];
	char longitud[100];
};

int yystopparser=0;
FILE  *yyin;

int yylex();
int yyerror();
extern struct struct_tablaSimbolos tablaSimbolos[1000]; 
extern int puntero_array;
int contadorTipos = 0;
char* auxTipoDato;
char matrizTipoDato[100][10];
char matrizVariables[100][10];
int contadorId = 0;
int agregarTipoEnTablaSimbolos(char* nombre, int contadorId);
void validarSintaxisDeclaracion(int, int);

%}
%token PROGRAM
%token END
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DISPLAY
%token GET
%token DIM
%token AS
%token COMP_IGUAL
%token COMP_MAYOR
%token COMP_MENOR
%token COMP_MAYOR_IGUAL
%token COMP_MENOR_IGUAL
%token COMP_DISTINTO
%token OPAR_ASIG
%token TIPO_INT
%token TIPO_FLOAT
%token TIPO_STRING
%token CONTAR
%token <num>CTE_ENTERA
%token <real>CTE_REAL
%token <str>CTE_STRING
%token OP_MAS 
%token OP_MENOS
%token OP_MULT
%token OP_DIV
%token OP_LOG_AND
%token OP_LOG_OR
%token OP_LOG_NOT
%token DOS_PUNTOS
%token PUN_Y_COM
%token COMA
%token <strid>ID
%token PAR_A
%token PAR_C
%token LLAVE_A
%token LLAVE_C
%token COR_A
%token COR_C

%union{
char * strid;
char * num;
char * real; 
char * str;
}

%%
programa: PROGRAM zona_declaracion algoritmo END { printf("\n***** Compilacion exitosa: OK *****\n");};
				  
zona_declaracion:	declaraciones;

declaraciones:	declaracion
				|declaraciones declaracion;

declaracion:	DIM { printf("***** Inicio declaracion de variables *****\n"); } COR_A lista_var COR_C  AS COR_A  lista_tipo COR_C{validarSintaxisDeclaracion(contadorTipos,contadorId); printf("*****\n Fin declaracion de variables *****\n");};


lista_var:		ID {strcpy(matrizVariables[contadorId],yylval.strid) ;  contadorId++; }
				| lista_var COMA  ID {strcpy(matrizVariables[contadorId],yylval.strid) ; contadorId++;};

 
lista_tipo:		lista_tipo COMA  TIPO_INT { auxTipoDato="int"; strcpy(matrizTipoDato[contadorTipos],auxTipoDato);  agregarTipoEnTablaSimbolos(matrizVariables[contadorTipos],contadorTipos); contadorTipos++; printf(" INT"); }
				| lista_tipo COMA  TIPO_FLOAT { auxTipoDato="float"; strcpy(matrizTipoDato[contadorTipos],auxTipoDato); agregarTipoEnTablaSimbolos(matrizVariables[contadorTipos],contadorTipos); contadorTipos++; printf(" REAL"); }
				|lista_tipo COMA  TIPO_STRING { auxTipoDato="string"; strcpy(matrizTipoDato[contadorTipos],auxTipoDato); agregarTipoEnTablaSimbolos(matrizVariables[contadorTipos],contadorTipos); contadorTipos++; printf(" STRING"); }
				| TIPO_INT { auxTipoDato="int"; strcpy(matrizTipoDato[contadorTipos],auxTipoDato); agregarTipoEnTablaSimbolos(matrizVariables[contadorTipos],contadorTipos); contadorTipos++; printf(" INT"); }
				|TIPO_FLOAT {  auxTipoDato="float"; strcpy(matrizTipoDato[contadorTipos],auxTipoDato); agregarTipoEnTablaSimbolos(matrizVariables[contadorTipos],contadorTipos); contadorTipos++; printf(" REAL"); }
				|TIPO_STRING { auxTipoDato="string"; strcpy(matrizTipoDato[contadorTipos],auxTipoDato); agregarTipoEnTablaSimbolos(matrizVariables[contadorTipos],contadorTipos); contadorTipos++; printf(" STRING"); };
              

algoritmo:		bloque {printf("\n***** Fin de bloque *****\n");};

bloque:			sentencia
				|bloque sentencia;

sentencia:		asignacion { printf(" - asignacion - OK \n"); }
				|seleccion { printf(" - seleccion - OK \n"); }
				|ciclo { printf(" - ciclo - OK \n"); }
				|entrada { printf(" - entrada - OK \n"); }
				|salida { printf(" - salida - OK \n"); }
				|contar { printf(" - contar - OK \n"); };

ciclo:			WHILE PAR_A condicion PAR_C LLAVE_A bloque LLAVE_C;
       
asignacion:		ID OPAR_ASIG expresion;
                  
          
seleccion: 		IF  PAR_A condicion PAR_C THEN bloque ENDIF
				| IF  PAR_A condicion PAR_C THEN bloque ELSE bloque ENDIF;

condicion:		comparacion 
				|comparacion OP_LOG_AND comparacion
				|comparacion OP_LOG_OR comparacion	
				|comparacion OP_LOG_NOT comparacion; 

comparacion:	expresion COMP_IGUAL expresion
				|expresion COMP_MAYOR expresion	
				|expresion COMP_MENOR expresion
				|expresion COMP_MAYOR_IGUAL expresion  
				|expresion COMP_MENOR_IGUAL expresion 
				|expresion COMP_DISTINTO expresion;


expresion:		expresion { printf(" expresion"); } OP_MAS termino { printf(" termino"); }
				|expresion { printf(" expresion"); }OP_MENOS termino { printf(" termino"); }
				|termino { printf(" termino"); };
				  
contar:			ID OPAR_ASIG CONTAR PAR_A factor PUN_Y_COM COR_A lista_a_contar COR_C PAR_C

lista_a_contar:	lista_a_contar COMA factor
				| factor
                    ;

termino:		termino OP_MULT factor { printf(" factor"); }
				|termino OP_DIV factor { printf(" factor"); }
				|factor { printf(" factor"); };
                         

factor:			ID 
				|CTE_ENTERA 
				|CTE_REAL 
				|CTE_STRING 
				|PAR_A expresion PAR_C;
 
entrada: 		GET ID;

salida:			DISPLAY CTE_STRING 
				|DISPLAY ID;
          
          
%%
 
int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nERROR! No se pudo abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
	escribirEnTablaSimbolos();
  }
  fclose(yyin);
  system ("Pause");
  return 0;
}

int agregarTipoEnTablaSimbolos(char* nombre, int contadorTipos)
{     
	if(contadorTipos>contadorId)
		return 0; 
	else
	{
		int i;          
        char lexema[50]; 
		lexema[0]='_';
		lexema[1]='\0';
		strcat(lexema,nombre);
                 
		for(i = 0; i < puntero_array; i++)
		{
			if(strcmp(tablaSimbolos[i].nombre, lexema) == 0)
			{
				if(tablaSimbolos[i].tipo[0] == '\0')
				strcpy(tablaSimbolos[i].tipo,matrizTipoDato[contadorTipos]);
		  
				return 1; 
			}
		}
	}
	
	return 0;	
}
