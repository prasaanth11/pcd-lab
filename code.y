%{
	#include <stdio.h>
	#include <stdlib.h>
	extern void yyerror(char *);
	int yylex(void);    
	extern FILE *yyin;
%}


%token PRINT STATEMENT
%token VARIABLE INTEGER
%token IF ELSE BTRUE BFALSE
%token WHILE FOR IN RANGE
%token APPEND REMOVE SORT COPY CLEAR COUNT EXTEND INDEX POP REVERSE
%nonassoc IF ELSE '=' NONE

%left AND OR 
%left GE LE EQ NE GT LT
%left '(' ')'
%left '+' '-' '*' '/' '%' SQUARE

%right '!' NOT


%%

pythonCode	:	program {
							printf("\nValid Python Program \n\n");
							return 0;
						}
			;

program		:	program program_list
			|
			;


program_list		:	print_statement
					|	loop_statement
					;


/* loops */
loop_statement		:	while_loop
					|	for_loop
					;

/* for loop */
for_loop			:	FOR  VARIABLE IN  RANGE '('  dataTypes  ')' ':' program_list
					|	FOR  VARIABLE IN  RANGE '('  boolean  ')' ':' program_list
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes  ')' ':' program_list
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes ',' dataTypes ')' ':' program_list
					|	FOR  VARIABLE IN  VARIABLE ':' program_list

					/* error in for loops */
					|	FOR  VARIABLE IN  boolean ':' program_list { yyerror("\n Boolean object is iteratable \n"); }
					|	FOR  VARIABLE IN  RANGE '('  boolean  ')'  program_list	{ yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ')' program_list { yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes  ')'  program_list { yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes ',' dataTypes ')' program_list { yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  ')' ':' program_list { yyerror("\n Range function is should not be empty in for loop. \n"); }
					;

/* while loop */
while_loop			:	WHILE expression ':' program_list
					|	WHILE dataTypes  ':' program_list
					|	WHILE boolean  ':' program_list

					/* error statement in while */
					|	WHILE expression program_list 		{ yyerror("\n Colon ':' is missing in the while statement \n"); }
					|	WHILE dataTypes  program_list 		{ yyerror("\n Colon ':' is missing in the while statement \n"); }
					|	WHILE boolean    program_list 		{ yyerror("\n Colon ':' is missing in the while statement \n"); }
					|	WHILE ':' program_list 		  		{ yyerror("\n Condition is missing in the while statement \n"); }
					|	WHILE expression ':' 				{ yyerror("\n Body statement is missing in the while loop \n"); }
					|	WHILE dataTypes  ':' 				{ yyerror("\n Body statement is missing in the while loop \n"); }
					|	WHILE boolean  ':' 					{ yyerror("\n Body statement is missing in the while loop \n"); }
					|	WHILE program_list ':' program_list	{ yyerror("\n Invalid while loop statement \n"); }
					;



/* print statement */
print_statement		:	PRINT '(' statements ')'
					|	PRINT '(' statements ')' ';'
					|	PRINT '(' VARIABLE '[' STATEMENT ']' ')'
					|	PRINT '(' VARIABLE '[' INTEGER ']' ')'

					/* error statement in print */
					|	PRINT '(' statements 				{ yyerror("\n Closing bracket is missing in the print statement \n"); }
					|	PRINT  statements ')' 				{ yyerror("\n Opening bracket is missing in the print statement \n"); }
					|	PRINT  statements  					{ yyerror("\n Opening and closing bracket are missing in the print statement \n"); }
					|	PRINT '(' statements ')' ';' ';'  	{ yyerror("\nIn python semicolon should not be at the end of the print statement \n"); }
					;


/* print content */
statements			:	STATEMENT statements
					|	expression
					|	'+' VARIABLE statements
					|	',' INTEGER statements
					|	','	boolean statements
					|	',' expression statements
					|	','	NONE statements
					|	VARIABLE statements
					|	dataTypes
					|	boolean
					|	NONE
					
					/* error statement in print - statement */
					|	VARIABLE '+'				{ yyerror("\nIn python print statement, there must be some string after string concatination  \n"); }
					|	NONE ','					{ yyerror("\nIn python print statement, invalid character ',' after an NONE  \n"); }
					|	NONE '+'					{ yyerror("\nIn python print statement, invalid character '+' after an NONE  \n"); }
					|	INTEGER ','					{ yyerror("\nIn python print statement, invalid character ',' after an INTEGER  \n"); }
					|	boolean ','					{ yyerror("\nIn python print statement, invalid character ',' after an boolean value  \n"); }
					|	expression ','				{ yyerror("\nIn python print statement, invalid character ',' after an expression  \n"); }
					|	'+'							{ yyerror("\nIn python print statement, invalid character ',' at the end without following any string or variable \n"); }
					|	','							{ yyerror("\nIn python print statement, invalid character ',' at the end without following any integer or boolean value  \n"); }
					|
					;


/* Expression evaluvation */
expression			:	dataTypes
					|	expression relationalOperations expression 
					|	expression relationalOperators expression 
					|	expression bitwiseOperations expression
					|	expression	bitwiseOperations boolean
					|	boolean	bitwiseOperations expression
					|	boolean	bitwiseOperations boolean
					
					/* error in expression evaluvation */
					|	expression relationalOperations	{ yyerror("\n Right hand side production is missing \n"); }
					|	expression relationalOperators	{ yyerror("\n Right hand side production is missing \n"); }
					|	expression bitwiseOperations	{ yyerror("\n Right hand side production is missing \n"); }
					|	boolean bitwiseOperations		{ yyerror("\n Right hand side production is missing \n"); }
					;



/* Relational operations + , * , - , / , % */
relationalOperations 	:	'-'
						|	'*'
						|	'/'
						|	'%'
						|	'+'
						|	SQUARE
						;
						

/* Relational statement operators > , < , >= , <= , == , !=  */
relationalOperators 	:	GT
						|	LT
						|	LE
						|	GE
						|	EQ
						|	NE
						;

/* Bitwise operation : or and not */
bitwiseOperations	:	OR
					|	AND
					|	NOT
					;	

dataTypes 	:	INTEGER
			|	VARIABLE
			;

boolean		:	BTRUE
			|	BFALSE
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
