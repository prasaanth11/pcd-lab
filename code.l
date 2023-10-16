%{
	#include <stdio.h>
	#include <stdlib.h>
	void yyerror( char *);
	#include "y.tab.h"	
%}


%%

"print" 	{ return PRINT; }
"("			{ return '('; }
")"			{ return ')'; }
"+"			{ return '+'; }
","			{ return ','; }

\"[^"]*\"  	{ yylval = atoi(yytext); return STATEMENT; }
\'[^"]*\'  	{ yylval = atoi(yytext); return STATEMENT; }

[0-9][0-9]*				{ yylval = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9_]*	{ yylval = atoi(yytext); return VARIABLE; }

[ \t\n] 	;

%%

int yywrap() {
	return 1;
}
