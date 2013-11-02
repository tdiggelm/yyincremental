%{
/* Copyright (c) 2013 Thomas Diggelmann. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#include <stdio.h>
#include "parser.h"
#include "yyparser.h"
#include "yylexer.h"
	
void yyerror(parser& ctx, yyscan_t scanner, const char *msg) {
	printf("parse error: %s\n", msg);
}

%}

%define api.push-pull push
%define api.pure

%lex-param { void* scanner }
%parse-param { parser& ctx }
%parse-param { void* scanner }

%union {
   long int integer;
}

%token EOL
%token <integer> INTEGER

%output  "yyparser.cc"
%defines "yyparser.h"

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