CC     = gcc
CFLAGS = -Wall -O2
LEX    = flex

all: greenscript

lex.yy.c: greenscript.l
	$(LEX) greenscript.l

greenscript: lex.yy.c
	$(CC) $(CFLAGS) -o greenscript lex.yy.c

testes: greenscript
	sh ../testes/correr_testes.sh

clean:
	rm -f lex.yy.c greenscript

.PHONY: all testes clean
