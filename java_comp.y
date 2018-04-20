
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>

	#define MAX_TYPE 40
	#define MAX_NAME 40
	#define MAX_VARIABLES 100
	#define MAX_FUNCTIONS 100
	#define MAX_PARAMETERS 10

	extern int nbLignes;
	extern char* yytext;
	int yylex(void);
	void yyerror(char *s);

	typedef struct{
		char type[MAX_TYPE];
		char name[MAX_NAME];
	}variable_t;

	typedef struct{
		char type[MAX_TYPE];
		char name[MAX_NAME];
		int params_nb;
		variable_t params[MAX_PARAMETERS];
	}function_t;

	variable_t variables[MAX_VARIABLES];
	function_t functions[MAX_FUNCTIONS];

	variable_t last_variable; 
	function_t last_function;
	char tmp[40];

	int var_nb=0,fct_nb=0,in_function=0;

	int add_variable(char *name){
		int i;
		if(var_nb>=MAX_VARIABLES){
			fprintf(stderr,"Max nb of variables reached (%d)\n",MAX_VARIABLES);
			return 0;
		}
		if(!in_function){
			for(i=0;i<var_nb;i++){
				if(!strcmp(name,variables[i].name)){
					fprintf(stderr,"Parameter %s already exists\n",last_variable.name);
					return 0;
				}
			}
			strcpy(variables[var_nb].name,name);
			last_variable=variables[var_nb];
			//printf("Variable %s ajoutee\n",name);
			++var_nb;
		}else{
			if(functions[fct_nb-1].params_nb>=MAX_PARAMETERS){
				fprintf(stderr,"Max nb of parameters reached (%d) in function %s\n",MAX_PARAMETERS,functions[fct_nb-1].name);
				return 0;
			}
			for(i=0;i<functions[fct_nb-1].params_nb;i++){
				if(!strcmp(name,functions[fct_nb-1].params[i].name)){
					fprintf(stderr,"Parameter %s already exists in function %s\n",name,last_function.name);
					return 0;
				}
			}
			strcpy(functions[fct_nb-1].params[i].name,name);
			//printf("Variable %s ajoutee a la fonction %s\n",name,functions[fct_nb-1].name);
			++(functions[fct_nb-1].params_nb);
		}
		return 1;
	}

	int add_function(char *name){
		int i;
		if(fct_nb>=MAX_FUNCTIONS){
			fprintf(stderr,"Max nb of functions reached (%d)\n",MAX_FUNCTIONS);
			return 0;
		}
		for(i=0;i<var_nb;i++){
			if(!strcmp(name,functions[i].name)){
				fprintf(stderr,"Function %s already exists\n",name);
				return 0;
			}
		}
		strcpy(functions[fct_nb].name,name);
		++fct_nb;
		return 1;
	}

	int var_exist(char *name){
		int i,j;
		
		if(!in_function){
			for(i=0;i<var_nb;i++){
				//printf("Checking variable %s / %s...\n",variables[i].name,name);
				if(!strcmp(name,variables[i].name))
					return 1;
			}
		}else{
			for(i=0;i<fct_nb;i++){
				//printf("Checking variable %s / %s...\n",variables[i].name,name);
				if(!strcmp(last_function.name,functions[i].name))
					for(j=0;j<functions[i].params_nb;j++){
						if(!strcmp(functions[i].params[j].name,name)){
							return 1;
						}
					}
			}
		}
		return 0;
	}

	int fct_exist(char *name){
		int i;
		for(i=0;i<fct_nb;i++){
			if(!strcmp(functions[i].name,name)){
				return 1;
			}
		}
		return 0;
	}

	int check_var(char *name){
		//printf("Checking %s..\n",name);
		if(!var_exist(name)){
			if(fct_exist(name))
				return 1;
			fprintf(stderr,"%s is not defined line %d. Abort mission\n",name,nbLignes);
			return 0;
		}
		return 1;
	}

	int check_params(char *name){
		int i;
		for(i=0;i<last_function.params_nb;i++){
			if(!strcmp(last_function.params[i].name,name))
				return 1;
		}
		fprintf(stderr,"Function %s : error with parameters. Abort mission\n",name);
		return 0; 
	}

	char* get_var_type(char *name){
		int i,j;
		if(!in_function){
			for(i=0;i<var_nb;i++){
				if(!strcmp(variables[i].name,name))
					return variables[i].type;
			}
			return NULL;
		}else{
			for(i=0;i<fct_nb;i++){
				if(!strcmp(functions[i].name,last_function.name))
					for(j=0;j<functions[i].params_nb;j++){
						if(!strcmp(functions[i].params[j].name,name)){
							return functions[i].params[j].type;
						}
					}
			}
		}
		
	}

	char* get_fct_type(char *name){
		int i;
		for(i=0;i<fct_nb;i++){
			if(!strcmp(functions[i].name,name))
				return functions[i].type;
		}
		return NULL;
	}

	
%}

%union {
	int intval;
	double floatval;
	char string[255];
}

%token <string>		ID
%token <string> 	TYPE
%token 				NUMBER
%token 				INCREMENTE DECREMENTE
%token 				PLUS MINUS TIMES DIV COMP_OPS
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
		: ACCESS STATIC TYPE ID {
			strcpy(last_variable.type,$3);
			strcpy(variables[var_nb].type,last_variable.type);
			if(!add_variable($4)) YYABORT;
		} Declaration Declarations
		| ACCESS STATIC VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| STATIC TYPE ID {
			strcpy(last_variable.type,$2);
			strcpy(variables[var_nb].type,last_variable.type);
			if(!add_variable($3)) YYABORT;
		} Declaration Declarations
		| STATIC VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| TYPE ID {
			strcpy(last_variable.type,$1);
			strcpy(variables[var_nb].type,last_variable.type); 
			if(!add_variable($2)) YYABORT;
		} Declaration Declarations
		| VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| ACCESS TYPE ID {
			strcpy(last_variable.type,$2);
			strcpy(variables[var_nb].type,last_variable.type);
			if(!add_variable($3)) YYABORT;
		} Declaration Declarations
		| ACCESS VOID ID O_PAREN PrototypeParameters C_PAREN O_ACCOL Instructions C_ACCOL Declarations
		| 
	;

	Declaration
		: O_PAREN {
			var_nb--;
			//printf("Variable %s is a function. Migrating...\n",variables[var_nb].name); 
			in_function=1;
			add_function(variables[var_nb].name);
		} PrototypeParameters C_PAREN {
			last_function=functions[fct_nb-1];
		} O_ACCOL {in_function=1;strcpy(tmp,"");} Declarations Instructions RETURN Calcul {if(strcmp(tmp,get_fct_type(last_function.name))){strcpy(tmp,"");YYABORT;}} S_COLON {in_function=0;} C_ACCOL
		| VariableDeclarations
		| EQUAL Calcul VariableDeclarations
	;

	VariableDeclarations
		: COMA ID {
			strcpy(variables[var_nb].type,last_variable.type);
			if(!add_variable($2)) YYABORT;
			} VariableDeclarations
		| COMA ID {
			strcpy(variables[var_nb].type,last_variable.type);
			if(!add_variable($2)) YYABORT;
			} EQUAL Calcul VariableDeclarations
		| S_COLON
	;

	PrototypeParameters
		: TYPE ID { 
			strcpy(variables[var_nb].type,$1);
			if(!add_variable($2)) YYABORT;
			} MultiplePrototypeParameters
		|
	;

	MultiplePrototypeParameters
		: COMA TYPE ID {
			if(!add_variable($3)) YYABORT;
			} MultiplePrototypeParameters
		|
	;

	Instructions
		: IF O_PAREN Comparison C_PAREN O_ACCOL Instructions C_ACCOL Else
		| Operation S_COLON Instructions
    	| Binding S_COLON Instructions
		| WHILE O_PAREN Comparison C_PAREN O_ACCOL Instructions C_ACCOL Instructions
    	| DO O_ACCOL Instructions C_ACCOL WHILE O_PAREN Comparison C_PAREN S_COLON Instructions
    	| FOR O_PAREN Binding S_COLON Comparison S_COLON Operation C_PAREN O_ACCOL Instructions C_ACCOL Instructions
    	| SOP O_PAREN Printable C_PAREN S_COLON Instructions
		|
    ;

	Else
		: ELSE IF O_PAREN Comparison C_PAREN O_ACCOL Instructions C_ACCOL Else
		| ELSE O_ACCOL Instructions C_ACCOL
		|

	Operation
		: Calcul
		| IncrementeDecremente
	;

	IncrementeDecremente
		: ID INCREMENTE
		| ID DECREMENTE
	;

	Calcul
		: NUMBER {strcpy(tmp,"int");}
		| ID O_PAREN Parameters C_PAREN {if(!check_var($1)) YYABORT;}
		| ID {if(!check_var($1)) YYABORT; strcpy(tmp,get_var_type($1));}
		| ID PLUS EQUAL Calcul {if(!check_var($1)) YYABORT;}
		| ID MINUS EQUAL Calcul {if(!check_var($1)) YYABORT;}
		| ID TIMES EQUAL Calcul {if(!check_var($1)) YYABORT;}
		| ID DIV EQUAL Calcul {if(!check_var($1)) YYABORT;}
		| NUMBER PLUS Calcul
		| NUMBER MINUS Calcul
		| NUMBER TIMES Calcul
		| NUMBER DIV Calcul
		| ID PLUS Calcul {if(!check_var($1)) YYABORT;} 
		| ID MINUS Calcul {if(!check_var($1)) YYABORT;}
		| ID TIMES Calcul {if(!check_var($1)) YYABORT;}
		| ID DIV Calcul {if(!check_var($1)) YYABORT;}
	;

	Binding
		: ID EQUAL Binding {if(!check_var($1)) YYABORT;} 
		| ID EQUAL O_PAREN Parameters C_PAREN {if(!check_var($1)) YYABORT;} 
		| ID EQUAL Calcul {if(!check_var($1)) YYABORT;} 
		| ID EQUAL STRING
	;

	Printable
		: STRING
		| STRING PLUS Printable
		| ID {if(!check_var($1)) YYABORT;}
		| ID PLUS {if(!check_var($1)) YYABORT;} Printable
	;

	Comparison
    	: Statement AND Comparison
		| Statement OR Comparison
    	| Statement COMP_OPS Comparison
		| O_PAREN Statement C_PAREN
		| Statement
    ;   

	Statement
		: BOOL_VALS
		| Calcul
		| NOT Statement
	;

	Parameters
		: ID MultipleParameters {if(!check_params($1)) YYABORT;}
		|
	;

	MultipleParameters
		: COMA ID MultipleParameters {if(!check_params($2)) YYABORT;}
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
	int i;
	printf("\nVariables : \n");
	for(i=0;i<var_nb;i++){
		printf("%d - %s\n",i,variables[i].name);
	}
	printf("\nFunctions : \n");
	for(i=0;i<fct_nb;i++){
		printf("%d - %s\n",i,functions[i].name);
	}
    return EXIT_SUCCESS;
}


