%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <string.h>

	int nbLignes=1;
	void yyerror(const char*s);	
%}

digit 				[0-9]
integer 			-?{digit}+
real 				-?{integer}("."{integer})?
number				{integer}|{real}
letter 				[a-zA-Z]
id 					{letter}({letter}|{digit}|_)*
type 				"double"|"int"|"char"|"float"|"String"|"boolean"
access				"public"|"private"|"protected"
sop					"System.out.println"
bool_vals			"true"|"false"
comp_ops			"<"|">"|"<="|">="|"=="|"!="
string 				\"(\\.|[^"\\])*\"
main_prototype		(({access}" static void main(String "{id}"[""]"")")|({access}" static void main(String""[""] "{id}")"))
comments 			"//".*"\n"|"/*"(.|"\n")*"*/"
whites 				[\t ]+

%%

"if" 				return IF;
"else"				return ELSE;
"do"				return DO;
"while"				return WHILE;
"for"				return FOR;
"class"				return CLASS;
"extends"			return EXTENDS;
"void"				return VOID;
"&&"				return AND;
"||"				return OR;
"{"					return O_ACCOL;
"}"					return C_ACCOL;
"["					return O_BRACK;
"]"					return C_BRACK;
"("					return O_PAREN;
")"					return C_PAREN;
";"					return S_COLON;
","					return COMA;
"+"					return PLUS;
"++"				return INCREMENTE;
"--"				return DECREMENTE;
"-"					return MINUS;
"*"					return TIMES;
"/"					return DIV;
"="					return EQUAL;
"!"					return NOT;
"return"			return RETURN;	
"static"			return STATIC;

{access}			return ACCESS;
{sop}				return SOP;
{bool_vals}			return BOOL_VALS;
{number}			return NUMBER;
{comp_ops}			return COMP_OPS;
{main_prototype}	return MAIN_PROTOTYPE;
{type}				strcpy(yylval.string,yytext); return TYPE;
{id}				strcpy(yylval.string,yytext); return ID;
{string}			return STRING;



{comments}			{}
{whites}			{}

\n 					{nbLignes++;}
. ;

%%

int yywrap(void){
	return 1;
}