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
%nonassoc IF ELSE '='

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

program_list	:	program_statement
				|	loop_statement
				|	conditional_statement
				|	assignmentations
				|	listOperations
				;

loop_statement		:	while_loop
					|	for_loop
					;

assignmentations	:	assignmentation
					;


listOperations		:	list_removing
					|	list_sorting
					|	list_appending
					|	join_list
					|	list_clear
					|	list_copy
					|	list_count
					|	list_extend
					|	list_index
					|	list_pop
					|	list_reverse
					;

list_reverse		:	VARIABLE '.' REVERSE '('  ')'
					|	VARIABLE '.' REVERSE '(' program_list  ')' { yyerror("\n Invalid syntax for REVERSE function of a list \n"); }
					;

list_pop			:	VARIABLE '.' POP '(' INTEGER ')'
					|	VARIABLE '.' POP '(' program_list  ')' { yyerror("\n Invalid syntax for POP function of a list \n"); }
					;

list_index			:	VARIABLE '.' INDEX '(' VARIABLE ')'
					|	VARIABLE '.' INDEX '(' program_list  ')' { yyerror("\n Invalid syntax for INDEX function of a list \n"); }
					;

list_extend			:	VARIABLE '.' EXTEND '(' VARIABLE ')'
					|	VARIABLE '.' EXTEND '(' program_list  ')' { yyerror("\n Invalid syntax for EXTEND function of a list \n"); }
					;

list_count			:	VARIABLE '.' COUNT '(' dataTypes ')'
					|	VARIABLE '.' COUNT '(' program_list  ')' { yyerror("\n Invalid syntax for COUNT function of a list \n"); }
					;

list_copy			:	VARIABLE '.' COPY '(' ')'
					|	VARIABLE '.' COPY '(' program_list  ')' { yyerror("\n Invalid syntax for COPY function of a list \n"); }
					;

list_clear			:	VARIABLE '.' CLEAR '(' ')'
					|	VARIABLE '.' CLEAR '(' program_list  ')' { yyerror("\n Invalid syntax for CLEAR function of a list \n"); }
					;

list_sorting		:	VARIABLE '.' SORT '(' ')'
					|	VARIABLE '.' SORT '(' program_list  ')' { yyerror("\n Invalid syntax for sort function of a list \n"); }
					;

list_removing		:	VARIABLE '.' REMOVE '(' item ')'
					|	VARIABLE '.' REMOVE '('  ')' { yyerror("\n Invalid syntax for remove function  of a list \n"); }
					;

list_appending		:	VARIABLE '.' APPEND '(' item ')'
					|	VARIABLE '.' APPEND '('  ')' { yyerror("\n Invalid syntax for append function  of a list \n"); }
					;

join_list			:	VARIABLE join_list
					|	'+' VARIABLE
					|	VARIABLE '+' { yyerror("\n Invalid syntax for joining the list. + wont come at the end \n"); }

item				:	dataTypes
					|	boolean
					;


/* assignment */
assignmentation		:	VARIABLE '=' INTEGER
					|	VARIABLE '=' VARIABLE
					|	VARIABLE '=' STATEMENT
					;

/* for loop */
for_loop			:	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes ',' dataTypes ')' ':' program_list
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes  ')' ':' program_list

/* while loop */
while_loop			:	WHILE expression ':' program_list
					|	WHILE dataTypes  ':' program_list
					|	WHILE boolean  ':' program_list

/* print statements */
program_statement	:	print_stmt
					|	expression { yyerror("\n Statement should be only enclosed in print statement \n"); }
					|	dataTypes { yyerror("\n Undefined statement \n"); }
					;

/* Conditional statements */
conditional_statement 	: 	IF expression ':' program_list %prec IF
						|	IF dataTypes  ':' program_list %prec IF
						|	conditional_statement ELSE ':' program_list
						;

/* print statement */
print_stmt			:	PRINT '(' statements ')'
					|	PRINT '(' statements ')' ';'
					|	PRINT '(' statements ')' ';' ';'  { yyerror("\nIn python semicolon should not be at the end of the print statement \n"); }			
					;

/* statement inside the print statement  */
statements			:	STATEMENT statements
					|	'+' statements
					|	',' statements
					|	expression statements
					|	dataTypes statements
					|	boolean statements
					|
					;

/* Relational Expression evaluvation */
expression 			:	dataTypes relationalOperations dataTypes
					|	dataTypes bitwiseOperations dataTypes
					|	boolean bitwiseOperations boolean
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
bitwiseOperations	:	OR
					|	AND
					|	NOT
					;		

/* Data types : int , variables , boolean */
dataTypes 			:	INTEGER
					|	VARIABLE
					// | 	NOT dataTypes
					;

boolean				:	BTRUE
					|	BFALSE
					// |	NOT boolean
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
