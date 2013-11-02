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

#include <assert.h>
#include "parser.h"
#include "yyparser.h"

//#define DEBUG

#ifdef DEBUG
#define RETURN(val) do { printf("@@@ TOKEN = %s\n", #val); return val; } while(0)
#define LOG(msg) printf("@@@ ## msg ## \n")
#else
#define RETURN(val) return val
#define LOG(msg)
#endif

#define YY_INPUT(buf, size, max_size) size = yyextra->yyinput(buf, max_size)

%}

%option outfile = "yylexer.cc" header-file="yylexer.h"
%option bison-bridge
%option noyywrap
%option nounput
%option yylineno
%option case-insensitive
%option reentrant
%option extra-type="parser*"

%%

[ \t]         			{ LOG("@@@ WHITESPACE\n"); }
						
[+-]?[0-9]{1,20}        {
							sscanf(yytext, "%ld", &yylval->integer);
							RETURN(INTEGER);
						}
												
\n						{ RETURN(EOL); }

.+						{ LOG("@@@ MISC\n"); return yytext[0]; }

%%

void parser::init()
{
	yylex_init_extra(this, &scanner);
	ps = yypstate_new();
}

void parser::destroy()
{
	yypstate_delete((yypstate*)ps);
	yylex_destroy(scanner);
}

void parser::parse()
{
	int status = 0;
	YYSTYPE val;
	int token;
	
	assert(status != YYPUSH_MORE);
	
	while(1) {
		token = yylex(&val, scanner);
		if (token == YY_NULL && status == YYPUSH_MORE) return;
		status = yypush_parse((yypstate*)ps, token, &val, *this, scanner);
		if (status != YYPUSH_MORE) return;
	}
}

int parser::feed(const char* buffer, size_t size)
{
	size_t newleng = bufleng + size;
	
	if (newleng > maxbufsize) {
		fprintf(stderr, "error: buffer larger than 1024bytes\n");
		return 0;
	}
	
	char* ptr = (char*)realloc(bufdata, newleng);
	if (!ptr) {
		perror("could not allocate buffer");
		return 0;
	}
	
	memcpy(ptr+bufleng, buffer, size);
	
	bufdata = ptr;
	bufleng = newleng;
	
	return 1;
}

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

int parser::yyinput(char* buffer, int size)
{
	int len = MIN(size, bufleng);
	
	// copy to yy buffer
	memcpy(buffer, bufdata, len);
	
	// truncate buffer
	int newleng = bufleng-len;
	memmove(bufdata, bufdata+len, newleng);
	if (newleng) {
		bufdata = (char*)realloc(bufdata, newleng);	
	} else {
		free(bufdata);
		bufdata = NULL;
	}
	bufleng = newleng;
	
	return len;
}
