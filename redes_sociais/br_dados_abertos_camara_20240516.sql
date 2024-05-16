# Consulta do somatório das despesas, agrupado por tipo de despesa; além da soma total do valor restituído
# à Câmara, quando houver
SELECT
categoria_despesa,
ROUND(SUM(valor_liquido),0) AS despesas,
ROUND(SUM(valor_restituicao),0) as valor_restituido
FROM `basedosdados.br_camara_dados_abertos.despesa`
WHERE nome_parlamentar = "Nome da(o) Deputada(o)"
AND ano_legislatura = 2023 #soma das despesas desde o início da atual legislatura até agora
GROUP BY categoria_despesa
ORDER BY despesas DESC;

# Consulta detalhada às despesas (valor_liquido), por tipo de despesa, data, valor de restituição à Câmara quando houver.
# nome_passageiro especifica a pessoa que fez a viagem quando a categoria de despesa se refere a esse tipo de gasto.

SELECT 
id_deputado,
categoria_despesa,
data_emissao,
valor_liquido,
nome_passageiro,
valor_restituicao
FROM `basedosdados.br_camara_dados_abertos.despesa` 
WHERE nome_parlamentar = "Nome da(o) Deputada(o)"
AND ano_legislatura = 2023 #soma das despesas desde o início da atual legislatura até agora
ORDER BY data_emissao ASC;
