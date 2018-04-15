
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

%token IF ELSE WHILE FOR CLASS SOP EXTENDS PUBLIC CHAINE PRIVATE PROTECTED RETURN STATIC TRUE FALSE INT DOUBLE BOOL FLOAT CHAR DO MAIN VOID STRING NOMBRE NOMVARIABLE
%right '=' 
%left '{' '[' '-' '*' '+' ET '.' '!' 
%nonassoc '<' '>'

%start Programme

%%
	Programme
		: Class { printf("Programme OK!\n");}
	;

	Class
		: ClassPrototype '{' Mode STATIC VOID MAIN '(' STRING '[' ']' NOMVARIABLE ')' '{' VariableDeclarations Instructions '}' '}'
	;

	ClassPrototype
		: Mode CLASS NOMVARIABLE
	;

	Mode
		: PUBLIC
		| PRIVATE
		| PROTECTED
		| 
	;

	VariableDeclarations
		: VariableDeclaration VariableDeclarations
		| 
	;

	VariableDeclaration
		: Type {for(i=0;i<strlen(yytext);i++){mesvariables[nbvars][i]=yytext[i];} nbvars++;} Variables ';' 
	;

	Variables
		: NOMVARIABLE ',' Variables
		| NOMVARIABLE
	;

	FunctionDeclarations
		: FunctionDeclaration FunctionDeclarations
		| 
	;

	FunctionDeclaration
		: Mode Type NOMVARIABLE '(' Parameters ')' '{' VariableDeclarations Instructions RETURN Expression ';' '}'
		| Mode Type NOMVARIABLE '(' Parameters ')' '{' Instructions RETURN Expression ';' '}'
	;

	Parameters 
		: Type NOMVARIABLE ',' Parameters
		| Type NOMVARIABLE
		| 
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
		|
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
		| FunctionDeclaration
		| IncrementeDecremente ';'
		| IF '(' Expression ')' '{' VariableDeclarations Instructions '}'
		| WHILE '(' Expression ')' '{' VariableDeclarations Instructions '}'
    	| NOMVARIABLE '=' Expression ';'
    	| NOMVARIABLE '[' Expression ']' '=' Expression ';'
    	| DO '{' VariableDeclarations Instructions '}' WHILE '(' Expression ')' ';'
    	| FOR '(' Type NOMVARIABLE '=' Expression ';' Expression ';' Instruction ')' '{' VariableDeclarations Instructions '}' 
    	| FOR '(' NOMVARIABLE '=' Expression ';' Expression ';' IncrementeDecremente ')' '{' VariableDeclarations Instructions '}' 
    	| SOP '(' Expression ')' ';'
    	| SOP '(' CHAINE '+' Expression')' ';'
    ;

    Expressions
    	: Expression
    	| Expression ',' Expressions
    	| 
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
    	|	NOMVARIABLE '(' Parameters ')'
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


