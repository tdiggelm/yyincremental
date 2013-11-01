FILES   = lexer.cc parser.cc server.cc
CC      = g++
CFLAGS  = -g -ansi -Wall
LDFLAGS = 

parse:		lexer.cc parser.cc test-parser.cc
			$(CC) $(CFLAGS) lexer.cc parser.cc test-parser.cc -o parse

server:		server.cc
			$(CC) $(CFLAGS) server.cc -o server -lev
 
lexer.cc:	lexer.l objects.h
			flex lexer.l
 
parser.cc:	parser.y lexer.cc objects.h 
			bison parser.y
 
clean:
			rm -f *.o *~ lexer.cc lexer.h parser.cc parser.h server parse