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
"elif"		{ return ELIF; }

"True"		{ return BTRUE; }
"False"		{ return BFALSE; }

":"			{ return ':'; }
";"			{ return ';'; }

"("			{ return '('; }
")"			{ return ')'; }

"+"			{ return '+'; }
","			{ return ','; }

"~"			{ return NOT; }
"not"		{ return NOT; }
"NOT"		{ return NOT; }

"&"			{ return AND; }
"AND"		{ return AND; }
"and"		{ return AND; }

"|"			{ return OR; }
"OR"		{ return OR; }
"or"		{ return OR; }

">="    	{ return GE; }
"<="    	{ return LE; }
"=="    	{ return EQ; }
"!="    	{ return NE; }
">"     	{ return GT; }
"<"     	{ return LT; }

\".*\"  	{ yylval = atoi(yytext); return STATEMENT; }
\'.*\'  	{ yylval = atoi(yytext); return STATEMENT; }


[0-9][0-9]*				{ yylval = atoi(yytext); return INTEGER; }
[a-zA-Z][a-zA-Z0-9]*	{ yylval = atoi(yytext); return VARIABLE; }

[ \t\n] 	;
.			{ yyerror("\nInvalid characters in the code\n"); }

%%

int yywrap() {
	return 1;
}
