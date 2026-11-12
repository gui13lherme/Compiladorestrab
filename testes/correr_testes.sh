#!/bin/sh
# Executa todos os testes e compara a saida com o resultado esperado.
# Uso (a partir da pasta src): sh ../testes/correr_testes.sh
DIR=$(cd "$(dirname "$0")" && pwd)
BIN="$DIR/../src/greenscript"
ok=0; falhou=0
for f in "$DIR"/*.gs; do
    nome=$(basename "$f" .gs)
    "$BIN" "$f" > "/tmp/$nome.out"
    if diff -q "/tmp/$nome.out" "$DIR/$nome.esperado" > /dev/null; then
        echo "OK      $nome"; ok=$((ok+1))
    else
        echo "FALHOU  $nome"; diff "/tmp/$nome.out" "$DIR/$nome.esperado"; falhou=$((falhou+1))
    fi
done
echo "Passaram: $ok | Falharam: $falhou"
[ "$falhou" -eq 0 ]
