##Observando os endereços do Censo 2022 em Campinas no BigQuery GeoViz
SELECT
	p1.ponto,
	p2.nome AS municipio
FROM `basedosdados.br_ibge_censo_2022.coordenada_endereco` AS p1
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS p2
ON p1.id_municipio = p2.id_municipio
WHERE nome = 'Campinas' 
