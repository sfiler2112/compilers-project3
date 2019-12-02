/* Compiler Theory and Design
   Duane J. Jarc */

// Edited by Sean Filer on 12/1/2019

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <array>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<float> symbols;

float result;
float *parameters;
int parameterCount;
int currentParameterIndex = 0;
%}

%error-verbose

%union
{
	CharPtr iden;
	Operators oper;
	float value;
}

%token <iden> IDENTIFIER REAL_LITERAL BOOL_LITERAL
%token <value> INT_LITERAL 

%token <oper> ADDOP MULOP RELOP REMOP EXPOP 
%token ANDOP OROP NOTOP
%token ARROW
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS THEN WHEN REAL OTHERS IF ENDIF CASE ENDCASE ELSE 

%type <value> body statement_ statement reductions expression and_expression relation term case_statement if_statement reduce_statement optional_reductions factor exponent primary case_ case
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

optional_variable:
	variable_ |
	;

variable_: 
	variable |
	variable_ variable;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

optional_parameters:
	parameter_ |
	;

parameter_:
	parameter |
	parameter_ ',' parameter ;

parameter:
	IDENTIFIER ':' type {symbols.insert($1, parameters[currentParameterIndex]); currentParameterIndex++;} ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	reduce_statement |
	if_statement |
	case_statement ;

case_statement:
	CASE expression IS case_ OTHERS ARROW statement_ ENDCASE {$$ = isnan($4) ? $7 : $4;} ;

if_statement:
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $2 == 0 ? $6 : $4;} ;

reduce_statement:
	REDUCE operator optional_reductions ENDREDUCE {$$ = $3;} ;


case_: 
	case_ case { $$ = isnan($1) ? $2 : $1;} |
	{$$ = NAN;}; 

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $<value>-2 == $2 ? $4 : NAN;}; 

operator:
	ADDOP |
	MULOP ;

optional_reductions:
	reductions |
	{$$ = $<oper>0 == ADD ? 0 : 1;};

reductions:
	statement_ |
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);};

expression: 
	expression OROP and_expression {$$ = $1 || $3;} |
	and_expression ;

and_expression:
	and_expression ANDOP relation {$$ = $1 && $3;} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} | 
	factor REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

exponent:
	primary EXPOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	NOTOP primary {$$ = !($2);}|
	INT_LITERAL |
	REAL_LITERAL {$$ = convertRealLiteral($1);} |
	BOOL_LITERAL {$$ = convertBoolLiteral($1);} | 
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	parameters = new float[argc-1];
	parameterCount = argc-1;

	for(int i = 0; i < parameterCount; i++)
	{
		parameters[i] = atof(argv[i+1]);
	}
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
