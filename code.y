%{
	#include <stdio.h>
	#include <stdlib.h>
	extern void yyerror(char *);
	int yylex(void);    
	extern FILE *yyin;
%}


%token PRINT STATEMENT
%token VARIABLE NUMBER
%left '(' ')'


%%

python_program 	: 	code{
							printf("Valid Python Program \n");
							return 0;
						}
				;

code 			: print_stmt
				;

print_stmt	: PRINT '(' statements ')'
			;

statements 	: STATEMENT
			| STATEMENT '+' VARIABLE
			| STATEMENT '+' statements
			| VARIABLE  '+' statements
			| STATEMENT ',' NUMBER
			| NUMBER ',' STATEMENT
			| VARIABLE
			| NUMBER
			// | expressions
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
