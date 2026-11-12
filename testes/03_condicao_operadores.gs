# Teste 3: condicao com SENAO e todos os operadores relacionais
SE (HUMIDADE(2) < 30) { REGAR(2,15); } SENAO { ESPERAR(60); }
SE (HUMIDADE(2) <= 30) { REGAR(2,15); }
SE (HUMIDADE(2) > 70) { ABRIR(); }
SE (HUMIDADE(2) >= 70) { ABRIR(); }
SE (HUMIDADE(2) == 50) { PARAR(); }
SE (HUMIDADE(2) != 50) { AQUECER(22); }
# os mesmos operadores sem espacos entre operandos e operadores
HUMIDADE(2)<30 HUMIDADE(2)<=30 HUMIDADE(2)>70
HUMIDADE(2)>=70 HUMIDADE(2)==50 HUMIDADE(2)!=50
