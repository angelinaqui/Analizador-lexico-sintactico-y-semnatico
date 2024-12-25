%{
/* 
Nombres de integrantes: 
Díaz González Rivas Ángel Iñaqui
Perez Delgado Erandy Estefanya
*/
#include "sintac2.tab.h"  // Incluir la cabecera generada por Bison que contiene las definiciones de tokens y tipos.
#include <stdio.h>        // Incluir la biblioteca estándar para funciones de entrada y salida.
#include <stdlib.h>       // Incluir la biblioteca para funciones estándar como `exit()`.
#include <string.h>       // Incluir la biblioteca para manipulación de cadenas.

extern int yylex();      // Declaración de la función de análisis léxico generada por Flex.
extern char *yytext;     // Declaración de la variable que contiene el texto de la última coincidencia de token.
extern FILE *yyin;       // Declaración del archivo de entrada para el análisis léxico.

void yyerror(const char *s);  // Declaración de la función de manejo de errores de Bison.
void imprimir_tipo(char *tipo);  // Declaración de la función que imprime el tipo de una variable.
%}

%union {
    char *str;  // Unión para almacenar cadenas (usada para tokens de tipo string).
}

%token <str> IDENTIFICADOR CARACTER ENTERO REAL CADENA c s z r   // Definición de tokens con sus tipos de valor.
%token ':'   // Token para el símbolo ":"
%token ','   // Token para el símbolo ","

%type <str> D tipo I_prima L Valor V  // Definición de los tipos de las reglas no terminales.

%%

/* Regla para el símbolo inicial (D) */
D: tipo L ':' { 
    imprimir_tipo($1);   // Imprime el tipo de la variable (valor de tipo).
    printf("\n");
} 
| /* vacío */ { 
    printf("Cadena vacía detectada\n");  // Si se detecta una cadena vacía, se imprime este mensaje.
    $$ = "";  // Asigna una cadena vacía a la variable semántica.
};

/* Regla para el tipo de la variable */
tipo: CARACTER { $$ = "CARACTER"; }  // Si se encuentra 'CARACTER', asigna el valor "CARACTER".
    | ENTERO { $$ = "ENTERO"; }      // Si se encuentra 'ENTERO', asigna el valor "ENTERO".
    | REAL { $$ = "REAL"; }          // Si se encuentra 'REAL', asigna el valor "REAL".
    | CADENA { $$ = "CADENA"; }      // Si se encuentra 'CADENA', asigna el valor "CADENA".
;

/* Regla para el identificador y su valor */
L: IDENTIFICADOR Valor I_prima { $$ = $1; }  // Si se encuentra un identificador seguido de su valor y posibles valores adicionales, asigna el identificador.
;

/* Regla para las continuaciones de la lista de valores (I_prima) */
I_prima: ',' IDENTIFICADOR Valor I_prima { $$ = $2; }  // Si se encuentra una coma, asigna el segundo valor (se continúa la lista).
       | { $$ = ""; }  // Si no se encuentra nada, asigna una cadena vacía.
;

/* Regla para el valor de la variable */
Valor: '~'V { $$ = $2; }  // Si se encuentra el símbolo '~', asigna el valor V.
     | { $$ = ""; }  // Si no se encuentra nada, asigna una cadena vacía.
;

/* Regla para los posibles valores de la variable */
V: c { $$ = "c"; }  // Si se encuentra 'c', asigna el valor "c".
 | s { $$ = "s"; }  // Si se encuentra 's', asigna el valor "s".
 | z { $$ = "z"; }  // Si se encuentra 'z', asigna el valor "z".
 | r { $$ = "r"; }  // Si se encuentra 'r', asigna el valor "r".
;

%%

/* Función para imprimir el tipo de la variable */
void imprimir_tipo(char *tipo) {
    printf("Las variables son de tipo %s\n", tipo);  // Imprime el tipo de variable (como "CARACTER", "ENTERO", etc.).
}

/* Función para manejar errores de análisis */
void manejar_error(const char *mensaje) {
    fprintf(stderr, "Se ha producido un error: %s\n", mensaje);  // Imprime un mensaje de error a stderr.
    exit(EXIT_FAILURE);  // Sale del programa con código de error.
}

/* Función de manejo de errores de Bison (yyerror) */
void yyerror(const char *s) {
    fprintf(stderr, "Error de sintaxis: %s\n", s);  // Imprime un mensaje de error de sintaxis.
}

/* Función de procesamiento de archivo línea por línea */
void procesar_archivo_linea_a_linea(const char *nombre_archivo) {
    FILE *archivo = fopen(nombre_archivo, "r");  // Abre el archivo de entrada para lectura.
    if (!archivo) {  // Si no se puede abrir el archivo, maneja el error.
        manejar_error("No se pudo abrir el archivo de entrada");
    }

    char buffer[256];  // Buffer para almacenar cada línea del archivo.
    while (fgets(buffer, sizeof(buffer), archivo)) {  // Lee el archivo línea por línea.
        size_t longitud = strlen(buffer);  // Obtiene la longitud de la línea.
        if (longitud > 0 && buffer[longitud - 1] == '\n') {
            buffer[longitud - 1] = '\0';  // Elimina el salto de línea al final de la cadena.
        }

        if (strlen(buffer) == 0) continue;  // Si la línea está vacía, se omite.

        FILE *archivo_temporal = tmpfile();  // Crea un archivo temporal para almacenar la línea.
        if (!archivo_temporal) {  // Si no se puede crear el archivo temporal, maneja el error.
            manejar_error("No se pudo crear el archivo temporal");
        }

        fputs(buffer, archivo_temporal);  // Escribe la línea en el archivo temporal.
        rewind(archivo_temporal);  // Rewinda el archivo temporal para leer desde el inicio.

        yyin = archivo_temporal;  // Establece el archivo temporal como la entrada para el análisis léxico.

        printf("\nProcesando Cadena: %s\n", buffer);  // Imprime la línea que está siendo procesada.
        yyparse();  // Llama a la función de análisis sintáctico.

        fclose(archivo_temporal);  // Cierra el archivo temporal.
        printf("\n");  // Imprime una línea en blanco para separar las salidas.
    }

    fclose(archivo);  // Cierra el archivo de entrada después de procesar todas las líneas.
}

/* Función principal */
int main(int argc, char **argv) {
    if (argc != 2) {  // Verifica que se haya pasado un archivo de entrada como argumento.
        fprintf(stderr, "Uso incorrecto: %s <archivo_de_entrada.txt>\n", argv[0]);  // Mensaje de uso incorrecto.
        return 1;  // Termina el programa con un código de error.
    }

    procesar_archivo_linea_a_linea(argv[1]);  // Procesa el archivo línea por línea.
    return 0;  // Termina el programa con éxito.
}
