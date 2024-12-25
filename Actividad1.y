%{
/* 
Nombres de integrantes:
Díaz González Rivas Ángel Iñaqui
Perez Delgado Erandy Estefanya
*/

// Inclusión de bibliotecas estándar necesarias para la funcionalidad del programa.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  

// Declaración de funciones externas
void yyerror(const char *s);    // Función para manejar errores de Bison
int yylex(void);                // Función generada por Flex para el análisis léxico
extern FILE *yyin;              // Variable global para asociar el archivo de entrada al analizador léxico
%}

%token a b c  // Definición de los tokens que serán utilizados en el analizador

%%

/* Definición de la gramática y las reglas de producción */

/* La regla de la producción 'F' define un punto de inicio para la gramática. 
   En este caso, 'F' se deriva en 'S' (que es una producción más compleja). */
F: S 
;

/* La regla para 'S' indica que 'S' puede derivar de un 'a' seguido de 'S' (recursión), 
   lo que hace que la producción de 'S' sea repetitiva, o bien un 'b' seguido de una llamada a la producción 'A'. */
S: 'a' S { printf("a"); }         // Si se recibe 'a', se imprime "a"
   | 'b' { printf("c"); } A        // Si se recibe 'b', se imprime "c" y se sigue con la producción A
   ;

/* La regla para 'A' indica que 'A' puede derivar de un 'b' seguido de una llamada recursiva a 'A' y luego 'c'. 
   También puede derivar solo con el token 'c'. La acción asociada imprime "c" o "b" según el caso. */
A: 'b' { printf("c"); } A 'c' { printf("b"); }   // Si se recibe 'b', seguido de una llamada recursiva a A y 'c', imprime "b"
   | 'c' { printf("b"); }    // Si se recibe solo 'c', se imprime "b"
   ;

%%

/* Función para manejar errores durante el análisis sintáctico. */
void manejar_error(const char *mensaje) {
    fprintf(stderr, "Se ha producido un error: %s\n", mensaje); // Muestra un mensaje de error
    exit(EXIT_FAILURE); // Termina la ejecución del programa en caso de error
}

/* Función para procesar el archivo de entrada línea por línea. */
void procesar_archivo_linea_a_linea(const char *nombre_archivo) {
    // Intentamos abrir el archivo especificado para lectura
    FILE *archivo = fopen(nombre_archivo, "r");
    if (!archivo) {
        manejar_error("No se pudo abrir el archivo de entrada");  // Si el archivo no se abre correctamente, muestra un error
    }

    char buffer[256]; // Variable para almacenar cada línea leída
    while (fgets(buffer, sizeof(buffer), archivo)) {
        // Eliminar el salto de línea al final de cada línea leída
        size_t longitud = strlen(buffer);
        if (longitud > 0 && buffer[longitud - 1] == '\n') {
            buffer[longitud - 1] = '\0';
        }

        // Si la línea está vacía, saltamos a la siguiente línea
        if (strlen(buffer) == 0) {
            continue; // Salta esta línea vacía y continúa con la siguiente
        }

        // Crear un archivo temporal para procesar la línea de entrada
        FILE *archivo_temporal = tmpfile();
        if (!archivo_temporal) {
            manejar_error("No se pudo crear el archivo temporal"); // Si no se puede crear el archivo temporal, muestra un error
        }

        // Escribir la línea en el archivo temporal
        fputs(buffer, archivo_temporal);
        rewind(archivo_temporal); // Volver al principio del archivo temporal para que Flex lo lea

        // Asignar el archivo temporal al analizador léxico
        yyin = archivo_temporal;

        // Mostrar la cadena que se está procesando
        printf("\nProcesando Cadena: %s\n", buffer);
        printf("Simbolo de Accion: ");

        // Llamada al analizador sintáctico
        yyparse();  // Inicia el análisis sintáctico utilizando la gramática definida

        fclose(archivo_temporal); // Cierra el archivo temporal después de procesarlo
        printf("\n"); // Separar las salidas de cada línea
    }

    fclose(archivo); // Cierra el archivo de entrada original
}

/* Función principal que coordina el procesamiento del archivo de entrada */
int main(int argc, char **argv) {
    // Verificar si el número de argumentos es el correcto (se espera 1 argumento: el nombre del archivo)
    if (argc != 2) {
        fprintf(stderr, "Uso incorrecto: %s <archivo_de_entrada.txt>\n", argv[0]);
        return 1;
    }

    // Procesar el archivo especificado como argumento
    procesar_archivo_linea_a_linea(argv[1]);

    return 0;
}

/* Función para manejar errores durante el análisis sintáctico, llamada por Bison */
void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s); // Muestra el mensaje de error durante el análisis sintáctico
}

