SELECT a.sigla_uf, nome, populacao AS populacao_2022 
FROM basedosdados.br_ibge_populacao.municipio a
INNER JOIN basedosdados.br_bd_diretorios_brasil.municipio b
ON a.id_municipio = b.id_municipio
WHERE ano = 2022 AND nome='Digite o Municipio'