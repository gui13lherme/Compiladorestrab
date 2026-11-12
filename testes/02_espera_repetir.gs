# Teste 2: espera e repeticao (lexicalmente valido)
ABRIR(); ESPERAR(60); FECHAR();

REPETIR(3) { ABRIR(); ESPERAR(60); FECHAR(); ESPERAR(30); }

# repeticao contendo SE e SENAO
REPETIR(5) {
	SE (HUMIDADE(1) < 40) { REGAR(1,20); } SENAO { ESPERAR(120); }
}
