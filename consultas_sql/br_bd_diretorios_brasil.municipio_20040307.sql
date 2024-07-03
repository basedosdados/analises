#Quantas UBSs existem em seu Campinas? 

SELECT a.id_municipio, nome, COUNT(DISTINCT(id_cnes)) as quantidade_ubs
FROM basedosdados.br_ms_cnes.estabelecimento a 
INNER JOIN basedosdados.br_bd_diretorios_brasil.municipio b
On a.id_municipio = b.id_municipio
WHERE nome = 'Campinas' AND tipo_unidade IN ('2') AND ano=2021
GROUP BY id_municipio, nome
