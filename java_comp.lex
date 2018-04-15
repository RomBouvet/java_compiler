%{
	#include "y.tab.h"
	extern int yylval;
	int nbLignes=1;
	void yyerror(const char*s);	
%}

LETTRE 				[a-zA-Z]
CHIFFRE 			[0-9]
LETTRECHIFFRE		({LETTRE}|{CHIFFRE})

%%

"if" 				{return IF;}
"do"				{return DO;}
"else"				{return ELSE;}
"while"				{return WHILE;}
"for"				{return FOR;}
"class"				{return CLASS;}
"extends"			{return EXTENDS;}
"public"			{return PUBLIC;}
"static"			{return STATIC;}
"private"			{return PRIVATE;}
"protected"			{return PROTECTED;}
"double"			{return DOUBLE;}
"true"				{return TRUE;}
"false"				{return FALSE;}
"float"				{return FLOAT;}
"int"				{return INT;}
"return"			{return RETURN;}
"char"				{return CHAR;}
"boolean"			{return BOOL;}
"main"				{return MAIN;}
"void"				{return VOID;}
"String"			{return STRING;}
"&&"				{return ET;}
"<"					{return '<';}
">"					{return '>';}
"+"					{return '+';}
"-"					{return '-';}
"."					{return '.';}
"="					{return '=';}
"*"					{return '*';}
"!"					{return '!';}
"("					{return '(';}
")"					{return ')';}
"{"					{return '{';}
"}"					{return '}';}
"["					{return '[';}
"]"					{return ']';}
","					{return ',';}
";"					{return ';';}

"//".*"\n"          {}
"/*"(.|"\n")*"*/" 	{}
"\"".*"\""			{return CHAINE;}

"System"".""out"".""println"		{return SOP;}
{LETTRE}("_"|{LETTRECHIFFRE})*			{return NOMVARIABLE;}
{CHIFFRE}+								{return NOMBRE;}
\n 										{nbLignes++;}
. ;
%%

int yywrap(void){
	return 1;
}