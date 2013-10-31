%{

#include "parser.h"
#include "objects.h"

#ifdef DEBUG
#define RETURN(val) do { printf("@@@ TOKEN = %s\n", #val); return val; } while(0)
#define LOG(msg) printf("@@@ " ## msg ## "\n")
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
	YYSTYPE token;
	do {
		int t = yylex(&token, scanner);
		status = yypush_parse((yypstate*)ps, t, &token, scanner);
	} while (status == YYPUSH_MORE);
}

int context::yyinput(char* buffer, int size)
{
	int len;
	len = read(fd, buffer, size);

	if (len == -1 && errno == EAGAIN) {
		// read again
	}

	return len;
}

int main()
{	
	context ctx(fileno(stdin));
	ctx.parse();
	
	return 0;
}
