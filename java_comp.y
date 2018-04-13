
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	extern int nbLignes;
	extern char* yytext;
	int i,	nbvars=0;
	char mesvariables[100][40];
	int yylex(void);
	void yyerror(char *s);
%}

%token IF ELSE WHILE FOR CLASS SOP EXTENDS PUBLIC CHAINE PRIVATE RETURN STATIC TRUE FALSE INT DOUBLE BOOL FLOAT CHAR DO MAIN VOID STRING NOMBRE NOMVARIABLE
%right '=' 
%left '{' '[' '-' '*' '+' ET '.' '!' 
%nonassoc '<' '>'

%start Programme

%%
	Programme
		: Classes ClassePrincipale { printf("Programme OK!\n");} Classes
	;

	ClassePrincipale 
		: PUBLIC CLASS NOMVARIABLE '{' PUBLIC STATIC VOID MAIN '(' STRING '[' ']' NOMVARIABLE ')' '{' DeclarationVariables Instructions '}' '}'
	;
	Classes
		: Classe Classes
		| /**/
	;
	Classe
		: CLASS NOMVARIABLE '{' DeclarationVariables Instructions DeclarationFonctions Instructions'}'
		| CLASS NOMVARIABLE '{' DeclarationFonctions Instructions '}'
		| CLASS NOMVARIABLE EXTENDS NOMVARIABLE '{' DeclarationVariables Instructions DeclarationFonctions Instructions '}'
		| CLASS NOMVARIABLE EXTENDS NOMVARIABLE '{' Instructions DeclarationFonctions Instructions'}'
	;

	DeclarationVariables
		: DeclarationVariable DeclarationVariables
		| /**/
	;

	DeclarationVariable
		: Type {for(i=0;i<strlen(yytext);i++){mesvariables[nbvars][i]=yytext[i];} nbvars++;} Variables ';' 
	;
	Variables
		: NOMVARIABLE ',' Variables
		| NOMVARIABLE
	;
	DeclarationFonctions
		: DeclarationFonction DeclarationFonctions
		| /**/
	;

	DeclarationFonction
		: PUBLIC Type NOMVARIABLE '(' Parametres ')' '{' DeclarationVariables Instructions RETURN Expression ';' '}'
		| PUBLIC Type NOMVARIABLE '(' Parametres ')' '{' Instructions RETURN Expression ';' '}'
	;

	Parametres 
		: Type NOMVARIABLE ',' Parametres
		| Type NOMVARIABLE
		| /**/
	;

	Type
		: INT
		| BOOL
		| VOID
		| STRING
		| DOUBLE
		| CHAR
	;

	Instructions
		: Instruction Instructions
		| /**/
	;
	IncrementeDecremente
		: NOMVARIABLE '+' '+'
		| NOMVARIABLE '-' '-'
		| '+' '+' NOMVARIABLE 
		| '-' '-' NOMVARIABLE 
		| NOMVARIABLE '=' Expression
	;

	Instruction
		: IF '(' Expression ')' '{' Instructions '}' ELSE '{' Instructions '}'
		| DeclarationFonction
		| IncrementeDecremente ';'
		| IF '(' Expression ')' '{' DeclarationVariables Instructions '}'
		| WHILE '(' Expression ')' '{' DeclarationVariables Instructions '}'
    	| NOMVARIABLE '=' Expression ';'
    	| NOMVARIABLE '[' Expression ']' '=' Expression ';'
    	| DO '{' DeclarationVariables Instructions '}' WHILE '(' Expression ')' ';'
    	| FOR '(' Type NOMVARIABLE '=' Expression ';' Expression ';' Instruction ')' '{' DeclarationVariables Instructions '}' 
    	| FOR '(' NOMVARIABLE '=' Expression ';' Expression ';' IncrementeDecremente ')' '{' DeclarationVariables Instructions '}' 
    	| SOP '(' Expression ')' ';'
    	| SOP '(' CHAINE '+' Expression')' ';'
    ;

    Expressions
    	: Expression
    	| Expression ',' Expressions
    	| /**/
    ;

    Expression
    	:   Expression ET Expression
    	|   Expression '<' Expression
    	|   Expression '>' Expression
   		|   Expression '+' Expression
    	|   Expression '-' Expression
    	|   Expression '*' Expression
    	| 	Expression '=' Expression
    	|   Expression '[' Expression ']'
    	|   Expression '.' NOMVARIABLE '(' Expressions ')'
    	|   NOMBRE
    	|   TRUE
    	|   FALSE
    	|   NOMVARIABLE
    	|	NOMVARIABLE '(' Parametres ')'
    	|   '!' Expression
    	|   '(' Expression ')'
    ;   
%%

void yyerror(char *s) {
    fprintf(stderr, "%s at line %d \n",s,nbLignes);
}
int main(void) {
    yyparse();
    return 0;
}


