%{
	#include <stdio.h>
	#include <stdlib.h>
	extern void yyerror(char *);
	int yylex(void);    
	extern FILE *yyin;
%}


%token PRINT STATEMENT
%token VARIABLE INTEGER
%token IF ELSE ELIF BTRUE BFALSE

%left AND OR 
%left GE LE EQ NE GT LT
%left '(' ')'
%right '!' NOT


%%

pythonCode	:	program{
						printf("\nValid Python Program \n\n");
						return 0;
					}
			;

program 	:	program print_stmt
			|	program conditional_stmt
			| 	dataTypes { yyerror("statements should be only enclosed in print statement"); }
			|
			;

conditional_stmt	:	IF expression program elif_stmt else_stmt
					;

elif_stmt	:	ELIF expression program elif_stmt
			| 
			;

else_stmt	:	ELSE program
			|
			;


print_stmt	:	PRINT '(' statements ')'
			|	PRINT '(' statements ')' ';'
			|	PRINT '(' statements ')' ';' ';'  { yyerror("\nIn python semicolon should not be at the end of the print statement \n"); }			
			;


statements	:	STATEMENT statements
			|	'+' statements
			|	',' statements
			|	expression statements
			|	
			;


expression 	:	dataTypes
			|	expression relationalOperations expression
			|	expression bitwiseOperations expression
			|	'!' expression
    		;

relationalOperations 	:	GT
						|	LT
						|	LE
						|	GE
						|	EQ
						|	NE
						;

bitwiseOperations		:	OR
						|	AND
						|	NOT
						;				

dataTypes 	: '!' dataTypes
			| INTEGER
			| VARIABLE
			| BFALSE
			| BTRUE
			;


%%

void yyerror(char *s) {
	fprintf(stderr , "%s \n" , s);
	exit(1);
}

int main(void) {
	
	yyin = fopen("inputFile.txt" ,"r");
	
	yyparse();

	return 0;
}
