/* Compiler Theory and Design
   Duane J. Jarc */

/* Edited by Sean Filer on 11-29-2019 */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
dashcomment	\-\-.*\n
slashcomment	\/\/.*\n
comment 	{dashcomment}|{slashcomment}
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
real		{int}\.{int}?([eE][\+\-]?{int})?
bool		(true)|(false)
punc		[\(\),:;]

%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSOREQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATEROREQUAL; return(RELOP); }
"=="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"**"		{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
"=>"		{ ECHO; return(ARROW); }
and		{ ECHO; return(ANDOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
if		{ ECHO; return(IF); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
not		{ ECHO; return(NOTOP); }
or		{ ECHO; return(OROP); }
others		{ ECHO; return(OTHERS); }
reduce		{ ECHO; return(REDUCE); }
real		{ ECHO; return(REAL); }
rem		{ ECHO; yylval.oper = REMAINDER; return(REMOP); }
returns		{ ECHO; return(RETURNS); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
{bool}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1);
			strcpy(yylval.iden, yytext); return(BOOL_LITERAL); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER); }
{real}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1);
			strcpy(yylval.iden, yytext); return(REAL_LITERAL); }
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
