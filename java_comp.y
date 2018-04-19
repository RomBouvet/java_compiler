
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	extern int nbLignes;
	extern char* yytext;
	int yylex(void);
	void yyerror(char *s);
	char variables[100][2][40];
	int var_nb=0;
%}

%union {
	int intval;
	double floatval;
	char string[255];
}

%token 				NUMBER
%token 				PLUS MINUS TIMES DIV COMP_OPS
%token <string> 	TYPE
%token <string>		ID
%token				VOID
%token				STRING
%token				BOOL_VALS
%token 				ACCESS 
%token 				EXTENDS
%token				MAIN_PROTOTYPE 
%token				SOP
%token 				O_PAREN C_PAREN
%token				O_ACCOL C_ACCOL
%token				O_BRACK	C_BRACK
%token				S_COLON COMA
%token 				NOT
%token				EQUAL
%token				CLASS STATIC
%token				RETURN
%token				AND OR
%token				DO FOR WHILE
%token 				IF ELSE

%start Programme

%%
	Programme
		: Class {printf("Programme OK\n");}
	;

	Class
		: ClassPrototype O_ACCOL Declarations Main C_ACCOL
	;

	ClassPrototype
		: ACCESS CLASS ID ClassInheritance
		| CLASS ID ClassInheritance
	;
	
	ClassInheritance
		: EXTENDS ID
		|
	;

	Declarations
		: ACCESS STATIC TYPE ID Declaration Declarations
		| ACCESS STATIC VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| STATIC TYPE ID Declaration Declarations
		| STATIC VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| TYPE ID Declaration Declarations
		| VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| ACCESS TYPE ID Declaration Declarations
		| ACCESS VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| 
	;

	Declaration
		: O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions RETURN Calcul S_COLON C_ACCOL
		| VariableDeclarations
	;

	VariableDeclarations
		: COMA ID VariableDeclarations
		| S_COLON
	;

	PrototypeParameters
		: TYPE ID MultiplePrototypeParameters
		|
	;

	MultiplePrototypeParameters
		: COMA TYPE ID MultiplePrototypeParameters
		|
	;

	Instructions
		: IF O_PAREN Comparison C_PAREN O_ACCOL Instructions C_ACCOL Else
		| Calcul S_COLON Instructions
    	| Binding S_COLON Instructions
		| WHILE O_PAREN Comparison O_PAREN O_ACCOL Instructions C_ACCOL Instructions
    	| DO O_ACCOL Instructions C_ACCOL WHILE O_PAREN Comparison C_PAREN S_COLON Instructions
    	| FOR O_PAREN Binding S_COLON Comparison S_COLON IncrementeDecremente C_PAREN O_ACCOL Instructions C_ACCOL Instructions
    	| SOP O_PAREN Printable C_PAREN S_COLON Instructions
		| ID O_PAREN Parameters C_PAREN
		|
    ;

	Else
		: ELSE IF O_PAREN Comparison C_PAREN O_ACCOL Instructions C_ACCOL Else
		| ELSE O_ACCOL Instructions C_ACCOL
		|

	Calcul
		: NUMBER PLUS Calcul
		| NUMBER MINUS Calcul
		| NUMBER TIMES Calcul
		| NUMBER DIV Calcul
		| ID PLUS Calcul
		| ID MINUS Calcul
		| ID TIMES Calcul
		| ID DIV Calcul
		| NUMBER
		| ID
	;

	IncrementeDecremente
		: ID PLUS PLUS
		| ID MINUS MINUS
		| ID PLUS EQUAL Calcul
		| ID MINUS EQUAL Calcul
		| ID TIMES EQUAL Calcul
		| ID DIV EQUAL Calcul
	;

	Binding
		: ID EQUAL Binding
		| ID EQUAL Calcul
	;

	Printable
		: STRING
		| STRING PLUS Printable
		| ID
		| ID PLUS Printable
	;

	Comparison
    	: Statement AND Comparison
		| Statement OR Comparison
    	| Statement COMP_OPS Statement
		| Statement
    ;   

	Statement
		: BOOL_VALS
		| Calcul
		| NOT Statement
	;

	Parameters
		: ID Parameters MultipleParameters
		|
	;

	MultipleParameters
		: COMA ID MultipleParameters
		|
	; 

	Main
		: MAIN_PROTOTYPE O_ACCOL Declarations Instructions C_ACCOL
	;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s at line %d \n",s,nbLignes);
}

int main(void) {
    yyparse();
    return EXIT_SUCCESS;
}


