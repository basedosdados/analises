SELECT a.nome, a.quantidade_nascimentos_ate_2010, b.nome as nome_municipio 
FROM `basedosdados.br_ibge_nomes_brasil.quantidade_municipio_nome_2010` a 
INNER JOIN `basedosdados.br_bd_diretorios_brasil.municipio`  b
ON a.id_municipio = b.id_municipio
WHERE a.nome = 'Seu nome' AND b.nome = 'Nome do Municipio'