%{
	#include <stdio.h>
	#include <stdlib.h>
	void yyerror( char *);
	#include "y.tab.h"	
%}


%%

"print" 	{ return PRINT; }
"if"		{ return IF; }
"else"		{ return ELSE; }
"True"		{ return BTRUE; }
"False"		{ return BFALSE; }
":"			{ return ':'; }
"("			{ return '('; }
")"			{ return ')'; }
"+"			{ return '+'; }
","			{ return ','; }

\".*\"  	{ yylval = atoi(yytext); return STATEMENT; }
\'.*\'  	{ yylval = atoi(yytext); return STATEMENT; }
";"			{ return ';'; }

[0-9][0-9]*				{ yylval = atoi(yytext); return INTEGER; }
[a-zA-Z][a-zA-Z0-9]*	{ yylval = atoi(yytext); return VARIABLE; }

[ \t\n] 	;
.			{ yyerror("\nInvalid characters in the code\n"); }

%%

int yywrap() {
	return 1;
}
