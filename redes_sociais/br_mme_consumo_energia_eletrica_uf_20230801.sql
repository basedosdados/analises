#Quantos MWh seu estado consumiu de energia de 2004 a 2021?
SELECT SUM(consumo) as  consumo, ano
FROM basedosdados.br_mme_consumo_energia_eletrica.uf 
WHERE tipo_consumo = 'Residencial' AND sigla_uf = 'Sigla da UF'
GROUP BY ano
ORDER BY ano DESC