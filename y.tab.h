/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUMBER = 258,
    PLUS = 259,
    MINUS = 260,
    TIMES = 261,
    DIV = 262,
    COMP_OPS = 263,
    TYPE = 264,
    ID = 265,
    VOID = 266,
    STRING = 267,
    BOOL_VALS = 268,
    ACCESS = 269,
    EXTENDS = 270,
    MAIN_PROTOTYPE = 271,
    SOP = 272,
    O_PAREN = 273,
    C_PAREN = 274,
    O_ACCOL = 275,
    C_ACCOL = 276,
    O_BRACK = 277,
    C_BRACK = 278,
    S_COLON = 279,
    COMA = 280,
    NOT = 281,
    EQUAL = 282,
    CLASS = 283,
    STATIC = 284,
    RETURN = 285,
    AND = 286,
    OR = 287,
    DO = 288,
    FOR = 289,
    WHILE = 290,
    IF = 291,
    ELSE = 292
  };
#endif
/* Tokens.  */
#define NUMBER 258
#define PLUS 259
#define MINUS 260
#define TIMES 261
#define DIV 262
#define COMP_OPS 263
#define TYPE 264
#define ID 265
#define VOID 266
#define STRING 267
#define BOOL_VALS 268
#define ACCESS 269
#define EXTENDS 270
#define MAIN_PROTOTYPE 271
#define SOP 272
#define O_PAREN 273
#define C_PAREN 274
#define O_ACCOL 275
#define C_ACCOL 276
#define O_BRACK 277
#define C_BRACK 278
#define S_COLON 279
#define COMA 280
#define NOT 281
#define EQUAL 282
#define CLASS 283
#define STATIC 284
#define RETURN 285
#define AND 286
#define OR 287
#define DO 288
#define FOR 289
#define WHILE 290
#define IF 291
#define ELSE 292

/* Value type.  */


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
