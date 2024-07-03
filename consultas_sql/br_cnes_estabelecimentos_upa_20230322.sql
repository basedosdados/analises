#Quantas UBSs existem em seu município? 

SELECT a.id_municipio, nome, COUNT(DISTINCT(id_cnes)) as quantidade_ubs
FROM basedosdados.br_ms_cnes.estabelecimento a 
INNER JOIN basedosdados.br_bd_diretorios_brasil.municipio b
On a.id_municipio = b.id_municipio
WHERE nome = 'Nome do seu Município' AND tipo_unidade IN ('2') AND ano=2021
GROUP BY id_municipio, nome