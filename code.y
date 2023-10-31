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
%token IMPORT AS FROM
%token DEF RETURN PASS
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

program		:	import_statement
			|	program_list program 
			|
			;


program_list		:	print_statement
					|	assignmentations
					|	conditional_statement
					|	loop_statement
					|	listOperations
					|	function
					;


/* IMPORT statement */
import_statement	:	IMPORT module_name
					|	IMPORT module_name AS VARIABLE
					|	FROM VARIABLE import_statement
					;


module_name			:	VARIABLE
					|	VARIABLE ',' module_name
					;


/* functions */
function			:	DEF VARIABLE '(' parameter ')' ':' function_body return_statement
					|	DEF VARIABLE '(' parameter ')' ';' 
					|	DEF INTEGER '(' parameter ')' ';' 									{ yyerror("\nFunction name is cannot be a number \n"); }
					|	DEF boolean '(' parameter ')' ';' 									{ yyerror("\nFunction name is cannot be a boolean \n"); }					
					|	DEF INTEGER '(' parameter ')' ':' function_body return_statement	{ yyerror("\nFunction name is cannot be a number \n"); }
					|	DEF boolean '(' parameter ')' ':' function_body return_statement	{ yyerror("\nFunction name is cannot be a boolean \n"); }
					|	DEF  '(' parameter ')' ':' function_body return_statement			{ yyerror("\nFunction name is missing\n"); }
					|	DEF VARIABLE parameter ')' ':' function_body return_statement		{ yyerror("\nOpening bracket after Function name is missing\n"); }
					|	DEF VARIABLE '(' parameter ':' function_body return_statement		{ yyerror("\nClosing bracket after Function name is missing\n"); }
					|	DEF VARIABLE '(' parameter ')' function_body return_statement		{ yyerror("\nColon after bracket is missing\n"); }
					;


parameter			:	VARIABLE parameter
					|	',' parameter
					|
					;

return_statement	:	
					|	RETURN 
					|	PASS
					|	RETURN boolean;
					|	RETURN VARIABLE;
					|	RETURN expression;
					;

function_body		:	program_list
					;				


/* assigmentation */
assignmentations	:	VARIABLE '=' dataTypes
					|	VARIABLE '=' expression
					|	VARIABLE '=' statements
					|	VARIABLE '=' list_assignment
					;


/* Conditional statements */
conditional_statement 	: 	IF expression ':' program_list %prec IF
						|	IF dataTypes  ':' program_list %prec IF
						|	IF boolean  ':' program_list %prec IF
						|	conditional_statement ELSE ':' program_list

						/* error statement in if condition */
						|	IF expression program_list %prec IF		{ yyerror("\n Colon ':' is missing in the if statement \n"); }
						|	IF dataTypes  program_list %prec IF		{ yyerror("\n Colon ':' is missing in the if statement \n"); }
						|	IF boolean  program_list %prec IF		{ yyerror("\n Colon ':' is missing in the if statement \n"); }
						|	conditional_statement ELSE program_list { yyerror("\n Colon ':' is missing in the else statement \n"); }
						|	IF ':' program_list %prec IF			{ yyerror("\n Condition is missing before the ':' in the if statement \n"); }
						|	IF program_list %prec IF				{ yyerror("\n Condition statement in the if statement \n"); }
						|
						;

list_assignment			:	'[' list_value ']'
						|	'[' list_value			{ yyerror("\nClosing bracket is missing in the list declaration \n"); }
						|	list_value	']'			{ yyerror("\nClosing bracket is missing in the list declaration \n"); }
						;

list_value				:	STATEMENT list_value
						|	boolean list_value
						|	dataTypes list_value
						|	'[' list_value ']'
						|	',' list_value
						|
						;


listOperations			:	list_removing
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
					|	'.' REVERSE '(' ')'  						{ yyerror("\n List name is missing before REVERSE function \n"); }
					|	VARIABLE '.' REVERSE ')'  					{ yyerror("\n Opening bracket is REVERSE function of a list \n"); }
					|	VARIABLE '.' REVERSE '('  					{ yyerror("\n Closing bracket is REVERSE function of a list \n"); }
					|	VARIABLE '.' REVERSE '(' dataTypes  ')' 	{ yyerror("\n Invalid syntax for REVERSE function of a list \n"); }
					|	VARIABLE '.' REVERSE '(' program_list  ')' 	{ yyerror("\n Invalid syntax for REVERSE function of a list \n"); }
					;

list_pop			:	VARIABLE '.' POP '(' ')'
					|	VARIABLE '.' POP '(' INTEGER ')'
					|	'.' POP '(' ')'  							{ yyerror("\n List name is missing before pop function \n"); }
					|	VARIABLE '.' POP ')'  						{ yyerror("\n Opening bracket is POP function of a list \n"); }
					|	VARIABLE '.' POP '('  						{ yyerror("\n Closing bracket is POP function of a list \n"); }
					|	VARIABLE '.' POP '(' dataTypes  ')' 		{ yyerror("\n Invalid syntax for POP function of a list \n"); }
					|	VARIABLE '.' POP '(' program_list  ')' 		{ yyerror("\n Invalid syntax for POP function of a list \n"); }
					;

list_index			:	VARIABLE '.' INDEX '(' dataTypes ')'
					|	VARIABLE '.' INDEX '('  ')'					{ yyerror("\n INDEX function requires a parameter \n"); }
					|	'.' INDEX '('  ')'							{ yyerror("\n List name is missing before INDEX function \n"); }
					|	'.' INDEX '(' dataTypes ')'					{ yyerror("\n List name is missing before INDEX function \n"); }
					|	VARIABLE '.' INDEX ')'  					{ yyerror("\n Opening bracket is INDEX function of a list \n"); }
					|	VARIABLE '.' INDEX '('  					{ yyerror("\n Closing bracket is INDEX function of a list \n"); }
					|	VARIABLE '.' INDEX '(' program_list  ')' 	{ yyerror("\n Invalid syntax for INDEX function of a list \n"); }
					;

list_extend			:	VARIABLE '.' EXTEND '(' VARIABLE ')'
					|	'.' EXTEND '(' ')'  						{ yyerror("\n List name is missing before EXTEND function \n"); }
					|	VARIABLE '.' EXTEND ')'  					{ yyerror("\n Opening bracket is INDEX function of a list \n"); }
					|	VARIABLE '.' EXTEND '('  					{ yyerror("\n Closing bracket is INDEX function of a list \n"); }
					|	VARIABLE '.' EXTEND '(' program_list  ')' 	{ yyerror("\n Invalid syntax for EXTEND function of a list \n"); }
					;

list_count			:	VARIABLE '.' COUNT '(' dataTypes ')'
					|	VARIABLE '.' COUNT '('  ')'					{ yyerror("\n COUNT function requires a parameter \n"); }
					|	'.' COUNT '(' ')'  							{ yyerror("\n List name is missing before COUNT function \n"); }
					|	VARIABLE '.' COUNT ')'  					{ yyerror("\n Opening bracket is COUNT function of a list \n"); }
					|	VARIABLE '.' COUNT '('  					{ yyerror("\n Closing bracket is COUNT function of a list \n"); }
					|	VARIABLE '.' COUNT '(' program_list  ')' 	{ yyerror("\n Invalid syntax for COUNT function of a list \n"); }
					;

list_copy			:	VARIABLE '.' COPY '(' ')'
					|	VARIABLE '.' COPY '(' dataTypes ')'			{ yyerror("\n COPY function does not requires a parameter \n"); }
					|	'.' COPY '(' ')'  							{ yyerror("\n List name is missing before COPY function \n"); }
					|	VARIABLE '.' COPY ')'  						{ yyerror("\n Opening bracket is COPY function of a list \n"); }
					|	VARIABLE '.' COPY '('  						{ yyerror("\n Closing bracket is COPY function of a list \n"); }
					|	VARIABLE '.' COPY '(' program_list  ')' 	{ yyerror("\n Invalid syntax for COPY function of a list \n"); }
					;

list_clear			:	VARIABLE '.' CLEAR '(' ')'
					|	VARIABLE '.' CLEAR '(' dataTypes ')'		{ yyerror("\n CLEAR function does not requires a parameter \n"); }
					|	'.' CLEAR '(' ')'  							{ yyerror("\n List name is missing before CLEAR function \n"); }
					|	VARIABLE '.' CLEAR ')'  					{ yyerror("\n Opening bracket is CLEAR function of a list \n"); }
					|	VARIABLE '.' CLEAR '('  					{ yyerror("\n Closing bracket is CLEAR function of a list \n"); }
					|	VARIABLE '.' CLEAR '(' program_list  ')' 	{ yyerror("\n Invalid syntax for CLEAR function of a list \n"); }
					;

list_sorting		:	VARIABLE '.' SORT '(' ')'
					|	VARIABLE '.' SORT '(' dataTypes ')'			{ yyerror("\n SORT function does not requires a parameter \n"); }
					|	'.' SORT '(' ')'  							{ yyerror("\n List name is missing before SORT function \n"); }
					|	VARIABLE '.' SORT ')'  						{ yyerror("\n Opening bracket is SORT function of a list \n"); }
					|	VARIABLE '.' SORT '('  						{ yyerror("\n Closing bracket is SORT function of a list \n"); }
					|	VARIABLE '.' SORT '(' program_list  ')' 	{ yyerror("\n Invalid syntax for sort function of a list \n"); }
					;

list_removing		:	VARIABLE '.' REMOVE '(' list_value ')'
					|	VARIABLE '.' REMOVE '(' dataTypes ')'
					|	VARIABLE '.' REMOVE '(' boolean ')'		
					|	'.' REMOVE '(' ')'  						{ yyerror("\n List name is missing before REMOVE function \n"); }
					|	VARIABLE '.' REMOVE list_value ')'			{ yyerror("\n Opening bracket is REMOVE function of a list \n"); }
					|	VARIABLE '.' REMOVE dataTypes ')'			{ yyerror("\n Opening bracket is REMOVE function of a list \n"); }
					|	VARIABLE '.' REMOVE  ')'					{ yyerror("\n Opening bracket is REMOVE function of a list \n"); }
					|	VARIABLE '.' REMOVE '('  					{ yyerror("\n Closing bracket is REMOVE function of a list \n"); }
					|	VARIABLE '.' REMOVE '('  list_value			{ yyerror("\n Closing bracket is REMOVE function of a list \n"); }
					|	VARIABLE '.' REMOVE '('  dataTypes			{ yyerror("\n Closing bracket is REMOVE function of a list \n"); }
					|	VARIABLE '.' REMOVE '('  ')' 				{ yyerror("\n Invalid syntax for remove function  of a list \n"); }
					;

list_appending		:	VARIABLE '.' APPEND '(' list_value ')'
					|	VARIABLE '.' APPEND '(' dataTypes ')'
					|	VARIABLE '.' APPEND '(' boolean ')'
					|	'.' APPEND '(' ')'  						{ yyerror("\n List name is missing before APPEND function \n"); }
					|	VARIABLE '.' APPEND list_value ')'			{ yyerror("\n Opening bracket is APPEND function of a list \n"); }
					|	VARIABLE '.' APPEND dataTypes ')'			{ yyerror("\n Opening bracket is APPEND function of a list \n"); }
					|	VARIABLE '.' APPEND  ')'					{ yyerror("\n Opening bracket is APPEND function of a list \n"); }
					|	VARIABLE '.' APPEND '('  					{ yyerror("\n Closing bracket is APPEND function of a list \n"); }
					|	VARIABLE '.' APPEND '('  list_value			{ yyerror("\n Closing bracket is APPEND function of a list \n"); }
					|	VARIABLE '.' APPEND '('  dataTypes			{ yyerror("\n Closing bracket is APPEND function of a list \n"); }
					|	VARIABLE '.' APPEND '('  ')' 				{ yyerror("\n Invalid syntax for append function  of a list \n"); }
					;

join_list			:	VARIABLE join_list
					|	'+' VARIABLE
					|	VARIABLE '+' { yyerror("\n Invalid syntax for joining the list. + wont come at the end \n"); }
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
					|	FOR  VARIABLE IN  boolean ':' program_list 				{ yyerror("\n Boolean object is iterable \n"); }
					|	FOR  VARIABLE IN  RANGE '('  boolean  ')'  program_list	{ yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ')' program_list { yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes  ')'  program_list { yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  dataTypes ',' dataTypes ',' dataTypes ')' program_list { yyerror("\n Colon missing after the closing bracket in for loop. \n"); }
					|	FOR  VARIABLE IN  RANGE '('  ')' ':' program_list 		{ yyerror("\n Range function is should not be empty in for loop. \n"); }
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
					|	PRINT '(' VARIABLE '[' list_value ']' ')'
					|	PRINT '(' VARIABLE list_value  ')'
					|	PRINT '(' VARIABLE '[' list_value ']''[' list_value ']'  ')'

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
					|	expression '='					{ yyerror("\n Right hand side production is missing \n"); }
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
