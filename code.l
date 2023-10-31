%{
	#include <stdio.h>
	#include <stdlib.h>
	void yyerror( char *);
	#include "y.tab.h"	
%}


%%

"print" 	{ return PRINT; }

"None"		{ return NONE; }

"import"	{ return IMPORT; }
"as"		{ return AS; }
"from"		{ return FROM; }

"is"		{ return IS; }
"len"		{ return LEN; }
"str"		{ return STR; }
"type"		{ return TYPE; }


"return"	{ return RETURN; }
"def"		{ return DEF; }
"pass"		{ return PASS; }

"if"		{ return IF; }
"else"		{ return ELSE; }

"True"		{ return BTRUE;  }
"False"		{ return BFALSE; }

19p
":"			{ return ':'; }
";"			{ return ';'; }
","			{ return ','; }

"["			{ return '['; }
"]"			{ return ']'; }

"("			{ return '('; }
")"			{ return ')'; }

"+"			{ return '+'; }
"-"			{ return '-'; }
"*"			{ return '*'; }
"/"			{ return '/'; }
"%"			{ return '%'; }
"**"		{ return SQUARE; }

"~"			{ return NOT; }
"not"		{ return NOT; }

"&"			{ return AND; }
"and"		{ return AND; }

"|"			{ return OR; }
"or"		{ return OR; }

"while"		{ return WHILE; }
"for"		{ return FOR;   }
"in"		{ return IN;    }
"range"		{ return RANGE; }

"append"	{ return APPEND; }
"remove"	{ return REMOVE; }
"clear"		{ return CLEAR;  }
"extend"	{ return EXTEND; }
"reverse"	{ return EXTEND; }
"index"		{ return INDEX;  }
"count"		{ return COUNT;  }
"sort"		{ return SORT;   }
"pop"		{ return POP;   }

"="			{ return '='; }
">="    	{ return GE; }
"<="    	{ return LE; }
"=="    	{ return EQ; }
"!="    	{ return NE; }
">"     	{ return GT; }
"<"     	{ return LT; }
"."			{ return '.'; }

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
