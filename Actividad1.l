%{
/* 
Nombres de integrantes: 
Díaz González Rivas Ángel Iñaqui
Perez Delgado Erandy Estefanya
*/

// Incluir la cabecera generada por Bison, que contiene las definiciones de tokens y tipos.
#include "Actividad1.tab.h"
%}

%%

a           { return 'a'; } /* Si el texto coincide con 'a', devuelve el token 'a'. */

b           { return 'b'; } /* Si el texto coincide con 'b', devuelve el token 'b'. */

c           { return 'c'; } /* Si el texto coincide con 'c', devuelve el token 'c'. */

\n          { return 0; } /* Si el texto es una nueva línea (representada por '\n'), retorna 0, que generalmente indica el final de la entrada. */

.           { } //Ignora cualquier otro carácter 

%%

/* Función yywrap: Se llama cuando el analizador llega al final del archivo de entrada.
   Retorna 1, lo que indica que no hay más entradas que analizar. */
int yywrap() {
    return 1;  // Retorna 1 para indicar que el análisis ha terminado.
}

