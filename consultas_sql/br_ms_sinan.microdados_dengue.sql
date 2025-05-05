
## Numero de casos de dengue e óbitos na sua cidade
SELECT ano,
    nome,
    COUNT(tipo_notificacao) AS total_casos,
    COUNT(CASE WHEN evolucao_caso = '2' THEN 1 END) AS total_obitos
FROM basedosdados.br_ms_sinan.microdados_dengue AS dengue
JOIN basedosdados.br_bd_diretorios_brasil.municipio AS dir
ON dengue.id_municipio_notificacao = dir.id_municipio
WHERE nome = "Nome do Seu Município" # Exemplo de escrita: "Itapuã do Oeste"
    AND classificacao_final IN ("10", "11", "12")
    AND tipo_notificacao = "2"
GROUP BY ano, nome;
