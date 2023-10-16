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
%left '(' ')'


%%

pythonCode	:	program{
						printf("\nValid Python Program \n\n");
						return 0;
					}
			;

program 	:	program print_stmt
			|	program if_stmt
			|
			;

if_stmt		:	IF conditions ':' print_stmt
			;

conditions	:	VARIABLE
			|	BTRUE
			|	BFALSE
			;

print_stmt	:	PRINT '(' statements ')'
			|	PRINT '(' statements ')' ';'
			|	PRINT '(' statements ')' ';' ';'  { yyerror("\nIn python semicolon should not be at the end of the print statement \n"); }
			;

statements	:	STATEMENT statements
			|	'+' statements
			|	',' statements
			|	VARIABLE statements
			|	INTEGER statements
			|
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
