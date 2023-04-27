SELECT a.nome, id_escola, endereco, telefone, porte, etapas_modalidades_oferecidas,
b.nome as nome_municipio
FROM `basedosdados.br_bd_diretorios_brasil.escola` a
INNER JOIN `basedosdados.br_bd_diretorios_brasil.municipio` b
ON a.id_municipio = b.id_municipio
WHERE b.nome = "Campinas"