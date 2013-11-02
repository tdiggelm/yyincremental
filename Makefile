CC      = g++
CFLAGS  = -g -ansi -Wall
LDFLAGS = 

parse:		yylexer.cc yyparser.cc test-parser.cc
			$(CC) $(CFLAGS) yylexer.cc yyparser.cc test-parser.cc -o parse

server:		server.cc
			$(CC) $(CFLAGS) server.cc -o server -lev
 
yylexer.cc:	yylexer.l parser.h
			flex yylexer.l
 
yyparser.cc:	yyparser.y yylexer.cc parser.h 
			bison yyparser.y
 
clean:
			rm -f *.o *~ yylexer.cc yylexer.h yyparser.cc yyparser.h server parse