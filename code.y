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

program		:	program program_list
			|
			;

/* list of program offering */
program_list	:	print_stmt 
				|	conditional_stmt
				| 	expression { yyerror("\n Statement should be only enclosed in print statement \n"); }
				|	dataTypes { yyerror("\n Undefined statement \n"); }
				;

conditional_stmt 	: 	if_stmt else_stmt
					;

if_stmt			:	IF expression ':' program_list 
				|	IF dataTypes ':' program_list
				;

else_stmt		: 	ELSE ':' program_list

/* print statement */
print_stmt	:	PRINT '(' statements ')'
			|	PRINT '(' statements ')' ';'
			|	PRINT '(' statements ')' ';' ';'  { yyerror("\nIn python semicolon should not be at the end of the print statement \n"); }			
			;

/* statement inside the print statement  */
statements	:	STATEMENT statements
			|	'+' statements
			|	',' statements
			|	expression statements
			|	dataTypes statements
			|
			;

/* Relational Expression evaluvation */
expression 	:	dataTypes relationalOperations dataTypes
			|	dataTypes bitwiseOperations dataTypes
			;

/* Relational statement operators > , < , >= , <= , == , !=  */
relationalOperations 	:	GT
						|	LT
						|	LE
						|	GE
						|	EQ
						|	NE
						;

/* Bitwise operation : or and not */
bitwiseOperations		:	OR
						|	AND
						|	NOT
						;		

/* Data types : int , variables , boolean */
dataTypes 	: INTEGER
			| VARIABLE
			| BTRUE
			| BFALSE
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
