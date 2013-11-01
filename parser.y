
%{
	#include <stdio.h>
	#include "objects.h"
	#include "parser.h"
	#include "lexer.h"
	
	void yyerror(context& ctx, yyscan_t scanner, const char *msg) {
		printf("parse error: %s\n", msg);
	}
%}

%define api.push-pull push
%define api.pure
%lex-param { void* scanner }
%parse-param { context& ctx }
%parse-param { void* scanner }

%union {
   long int integer;
}

%token EOL
%token <integer> INTEGER

%output  "parser.cc"
%defines "parser.h"

%%

stmt	: line
		| stmt line
		| error
			{
				yyerrok;
				yyclearin;
			}
		;
		
line	: /*empty*/ EOL
		| INTEGER EOL { ctx.foundint($1); }
		;

%%