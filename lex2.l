%{
/* 
Nombres de integrantes: 
Díaz González Rivas Ángel Iñaqui
Perez Delgado Erandy Estefanya
*/
#include "sintac2.tab.h"  // Incluir la cabecera generada por Bison para las definiciones de tokens y las acciones semánticas
#include <stdio.h>        // Incluir la biblioteca estándar de entrada y salida
#include <stdlib.h>       // Incluir la biblioteca estándar para funciones de asignación de memoria y otras utilidades
#include <string.h>       // Incluir la biblioteca para funciones de manipulación de cadenas
%}

%%

"caracter" { 
    yylval.str = strdup("caracter");  // Almacena el valor del token en yylval.str
    printf("Token: CARACTER\n");       // Imprime el tipo de token detectado
    return CARACTER;                  // Devuelve el token CARACTER
}

"entero" { 
    yylval.str = strdup("entero"); 
    printf("Token: ENTERO\n");
    return ENTERO;
}

"real" {   
    yylval.str = strdup("real"); 
    printf("Token: REAL\n");
    return REAL;
}

"cadena" { 
    yylval.str = strdup("cadena"); 
    printf("Token: CADENA\n");
    return CADENA;
}

[a-zA-Z_][a-zA-Z0-9_]* { 
    printf("Token: IDENTIFICADOR, Valor: %s\n", yytext); // Imprime el valor del identificador
    yylval.str = strdup(yytext);  // Almacena el valor del identificador en yylval.str
    return IDENTIFICADOR;         // Devuelve el token IDENTIFICADOR
}

[0-9]+ { 
    printf("Token: ENTERO, Valor: %s\n", yytext); // Imprime el valor del número entero
    yylval.str = strdup(yytext);  // Almacena el valor del número entero
    return z;  // Devuelve el token z (se refiere al valor entero)
}

[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? { 
    printf("Token: REAL, Valor: %s\n", yytext); // Imprime el valor del número real
    yylval.str = strdup(yytext);  // Almacena el valor del número real
    return r;  // Devuelve el token r (se refiere al valor real)
}

\'([^\'\\]|\\.)*\' { 
    printf("Token: CARACTER, Valor: %s\n", yytext); // Imprime el valor del carácter
    yylval.str = strdup(yytext);  // Almacena el valor del carácter
    return c;  // Devuelve el token c (carácter)
}

\"([^\"\\]|\\.)*\" { 
    printf("Token: CADENA, Valor: %s\n", yytext); // Imprime el valor de la cadena
    yylval.str = strdup(yytext);  // Almacena el valor de la cadena
    return s;  // Devuelve el token s (cadena)
}

[ \t\n\r]+  { 
    // No hace nada, solo ignora estos caracteres
}

";" { 
    printf("Token: ;\n"); // Imprime el token ";"
    return ';';  // Devuelve el token ';'
}

","[ \t]*  { 
    printf("Token: ,\n"); // Imprime el token ","
    return ',';  // Devuelve el token ','
}

"~" { 
    printf("Token: ~\n"); // Imprime el token "~"
    return '~';  // Devuelve el token '~'
}

":" { 
    printf("Token: :\n"); // Imprime el token ":"
    return ':';  // Devuelve el token ':'
}

. { 
    printf("Caracter desconocido: %s\n", yytext); // Imprime el valor del carácter desconocido
}

%%

// Función que indica que el análisis léxico ha terminado
int yywrap() {
    return 1;  // Siempre retorna 1 para indicar que no hay más entradas
}
