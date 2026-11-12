/*
 * GreenScript - Analisador lexical (TP1 de Compiladores, UTAD)
 *
 * Le o ficheiro indicado na linha de comandos e escreve, por ordem de
 * ocorrencia, uma linha por token no formato:
 *      <linha> <CATEGORIA> <lexema>
 * Os erros lexicais sao escritos no mesmo fluxo (stdout), na posicao em que
 * ocorrem, no formato:
 *      <linha> ERRO_LEXICO <lexema>  (<motivo>)
 * No fim e apresentado o resumo:
 *      Tokens: N | Erros lexicais: M
 */

%option noyywrap
%option nounput
%option noinput

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int linha      = 1;   /* linha atual (comeca em 1)          */
static int n_tokens   = 0;   /* total de tokens reconhecidos       */
static int n_erros    = 0;   /* total de erros lexicais            */

/* Emite um token valido. */
static void token(const char *categoria)
{
    printf("%d %-14s %s\n", linha, categoria, yytext);
    n_tokens++;
}

/* Emite um erro lexical com o lexema completo e o motivo. */
static void erro(const char *motivo)
{
    printf("%d %-14s %s  (%s)\n", linha, "ERRO_LEXICO", yytext, motivo);
    n_erros++;
}

/* Classifica um candidato lexical invalido para um diagnostico mais claro. */
static void erro_candidato(void)
{
    if (strncmp(yytext, "EST-", 4) == 0)
        erro("identificador de estufa malformado");
    else if (yytext[0] >= '0' && yytext[0] <= '9')
        erro("inteiro malformado");
    else
        erro("sequencia invalida");
}
%}

/* ---------- Definicoes regulares ---------- */
DIGITO      [0-9]
MAIUSCULA   [A-Z]
INTEIRO     0|[1-9]{DIGITO}*
ID_ESTUFA   EST-{MAIUSCULA}{2}{DIGITO}{2}
CANDIDATO   [A-Za-z0-9_-]+
UTF8_MULTI  [\xC2-\xF4][\x80-\xBF]+

%%

 /* ---------- Separadores e comentarios ---------- */
\r\n|\n             { linha++; }
[ \t\r]+            { /* ignorar espacos, tabulacoes e CR isolado */ }
"#"[^\n]*           { /* comentario ate ao fim da linha (ou do ficheiro) */ }

 /* ---------- Palavras reservadas ---------- */
 /* Ganham ao CANDIDATO apenas quando ocupam a sequencia inteira
    (mesmo comprimento -> vence a regra que aparece primeiro). */
"LIGAR"             { token("LIGAR"); }
"DESLIGAR"          { token("DESLIGAR"); }
"ABRIR"             { token("ABRIR"); }
"FECHAR"            { token("FECHAR"); }
"AQUECER"           { token("AQUECER"); }
"PARAR"             { token("PARAR"); }
"REGAR"             { token("REGAR"); }
"ESPERAR"           { token("ESPERAR"); }
"SE"                { token("SE"); }
"SENAO"             { token("SENAO"); }
"HUMIDADE"          { token("HUMIDADE"); }
"REPETIR"           { token("REPETIR"); }

 /* ---------- Identificador de estufa e inteiro ---------- */
{ID_ESTUFA}         { token("ID_ESTUFA"); }
{INTEIRO}           { token("INTEIRO"); }

 /* ---------- Candidato lexical invalido ----------
    Qualquer sequencia maxima de letras, algarismos, '-' ou '_' que nao
    corresponda integralmente a uma das regras anteriores (seria mais longa
    do que elas) origina um unico erro, sem tokens parciais. */
{CANDIDATO}         { erro_candidato(); }

 /* ---------- Operadores relacionais (correspondencia mais longa) ---------- */
"<="                { token("MENOR_IGUAL"); }
">="                { token("MAIOR_IGUAL"); }
"=="                { token("IGUAL"); }
"!="                { token("DIFERENTE"); }
"<"                 { token("MENOR"); }
">"                 { token("MAIOR"); }

 /* ---------- Delimitadores ---------- */
"("                 { token("ABRE_PAR"); }
")"                 { token("FECHA_PAR"); }
"{"                 { token("ABRE_CHAVETA"); }
"}"                 { token("FECHA_CHAVETA"); }
","                 { token("VIRGULA"); }
";"                 { token("PONTO_VIRG"); }

 /* ---------- Caracteres nao reconhecidos ---------- */
"="                 { erro("'=' isolado nao e operador"); }
"!"                 { erro("'!' isolado nao e operador"); }
{UTF8_MULTI}        { erro("caracter nao reconhecido"); }
.                   { erro("caracter nao reconhecido"); }

%%

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <ficheiro.gs>\n", argv[0]);
        return 2;
    }

    yyin = fopen(argv[1], "rb");
    if (yyin == NULL) {
        perror(argv[1]);
        return 2;
    }

    yylex();
    fclose(yyin);

    printf("Tokens: %d | Erros lexicais: %d\n", n_tokens, n_erros);
    return n_erros > 0 ? 1 : 0;
}
