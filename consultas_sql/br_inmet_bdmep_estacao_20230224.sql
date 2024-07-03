SELECT a.id_municipio,
id_estacao,
estacao,
data_fundacao,
latitude,
longitude,
altitude,
nome
FROM `basedosdados.br_inmet_bdmep.estacao` AS a
INNER JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS b
ON a.id_municipio = b.id_municipio
WHERE nome = 'Nome do seu município'