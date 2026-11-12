# TP1 – Análise lexical da linguagem GreenScript

Compiladores, Licenciatura em Engenharia Informática, UTAD

Grupo: Guilherme Silva(2025156920), Tiago Jales(2025166470), Rui Lopes(2025162355) 

## Ferramentas utilizadas
- GNU Flex 2.6.4
- GCC (qualquer compilador C99)
- GNU Make (opcional)
- Linux (testado em Ubuntu 24.04); também funciona em macOS ou em WSL

Instalação em Ubuntu/Debian: `sudo apt install flex gcc make`

## Estrutura
```
src/greenscript.l        especificação FLEX do analisador
src/Makefile             compilação
testes/*.gs              ficheiros de entrada
testes/*.esperado        saída esperada de cada teste
testes/correr_testes.sh  executa os testes e compara com o esperado
relatorio.pdf            relatório
```

## Compilação
```
cd src
make
```
Sem `make`:
```
cd src
flex greenscript.l
gcc -Wall -O2 -o greenscript lex.yy.c
```

## Execução
```
./greenscript <caminho/do/ficheiro.gs>
```
Exemplo:
```
./greenscript ../testes/09_exemplo_enunciado.gs
```

## Formato da saída
Uma linha por token, pela ordem de ocorrência: `linha CATEGORIA lexema`.
Os erros lexicais aparecem na mesma sequência: `linha ERRO_LEXICO lexema  (motivo)`.
No fim: `Tokens: N | Erros lexicais: M`.

Categorias: o nome da própria palavra reservada (`LIGAR`, `DESLIGAR`, `ABRIR`, `FECHAR`, `AQUECER`,
`PARAR`, `REGAR`, `ESPERAR`, `SE`, `SENAO`, `HUMIDADE`, `REPETIR`), `ID_ESTUFA`, `INTEIRO`, `ABRE_PAR`,
`FECHA_PAR`, `ABRE_CHAVETA`, `FECHA_CHAVETA`, `VIRGULA`, `PONTO_VIRG`, `MENOR`, `MENOR_IGUAL`, `MAIOR`,
`MAIOR_IGUAL`, `IGUAL`, `DIFERENTE` e `ERRO_LEXICO`.

Código de saída do programa: 0 sem erros lexicais, 1 com erros lexicais, 2 em caso de erro de utilização.

## Testes
```
cd src
make testes          # ou: sh ../testes/correr_testes.sh
```

| Teste | Descrição |
|---|---|
| 01_comandos_simples | todos os comandos simples (válido) |
| 02_espera_repetir | ESPERAR, REPETIR e REPETIR contendo SE/SENAO (válido) |
| 03_condicao_operadores | SE/SENAO com os 6 operadores, com e sem espaços (válido) |
| 04_sintaxe_incorreta | tokens válidos em sequências sintaticamente incorretas, incluindo `LIGAR();` (válido) |
| 05_erros_candidatos | sequências inválidas: `LIGARX`, `ligar`, `EST-AA001`, `012`, `12abc`, … |
| 06_erros_caracteres | `@`, `=` e `!` isolados, `<==`, `+`, `*`, `.`, UTF-8 fora de comentários, … |
| 07_comentarios_separadores | apenas comentários e separadores: 0 tokens e 0 erros |
| 08_vazio | ficheiro vazio: 0 tokens e 0 erros |
| 09_exemplo_enunciado | exemplo da secção 5 do enunciado |
| 10_crlf_fim_ficheiro | terminações CRLF e fim de ficheiro sem mudança de linha |
