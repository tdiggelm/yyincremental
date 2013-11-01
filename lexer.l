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
#include "objects.h"
#include "parser.h"

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

%option outfile = "lexer.cc" header-file="lexer.h"
%option bison-bridge
%option noyywrap
%option case-insensitive
%option reentrant
%option extra-type="context*"

%%

[ \t]         			{ LOG("@@@ WHITESPACE\n"); }
						
[+-]?[0-9]+           	{
							sscanf(yytext, "%ld", &yylval->integer); 
							RETURN(INTEGER);
						}
												
\n						{ RETURN(EOL); }

.+						{ LOG("@@@ MISC\n"); return yytext[0]; }

%%

void context::init()
{
	yylex_init_extra(this, &scanner);
	ps = yypstate_new();
}

void context::free()
{
	yypstate_delete((yypstate*)ps);
	yylex_destroy(scanner);
}

void context::parse()
{
	int status;
	YYSTYPE val;
	do {
		int token = yylex(&val, scanner);
		if (token == YY_NULL && status == YYPUSH_MORE) return;
		status = yypush_parse((yypstate*)ps, token, &val, *this, scanner);
	} while (status == YYPUSH_MORE);
}

int context::feed(const char* buffer, size_t size)
{
	size_t newleng = bufleng + size;
	
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

void context::parse(const char* buffer, int size)
{
	YY_BUFFER_STATE buf = yy_scan_bytes(buffer, size, scanner);
	int status;
	YYSTYPE val;
	do {
		int token = yylex(&val, scanner);
		// if EOF is reached but parser expects more don't feed EOF to parser
		if (token == YY_NULL && status == YYPUSH_MORE) return;
		status = yypush_parse((yypstate*)ps, token, &val, *this, scanner);
	} while (status == YYPUSH_MORE);
	yy_delete_buffer(buf, scanner);
	
}

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

int context::yyinput(char* buffer, int size)
{
	int len = MIN(size, bufleng);
	
	// copy to yy buffer
	memcpy(buffer, bufdata, len);
	
	// truncate buffer
	int newleng = bufleng-len;
	memmove(bufdata, bufdata+len, newleng);
	bufdata = (char*)realloc(bufdata, newleng);
	bufleng = newleng;
	
	return len;
}

/*int context::yyinput(char* buffer, int size)
{
	int len;
	len = read(fd, buffer, size);

	if (len < 0) {
		if (len == -1 && errno == EAGAIN) {
			// read again
			return -1;
		}
		
		// cleanup && close socket
		close(fd);
	}


	return len;
}*/
