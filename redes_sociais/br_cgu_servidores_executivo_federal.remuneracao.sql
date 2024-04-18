SELECT ROUND (AVG (remuneracao_bruta_brl)) as media_servidores 
FROM `basedosdados.br_cgu_servidores_executivo_federal.remuneracao` 
WHERE ano = 2024 AND mes IN (1,2,3)

SELECT MAX(remuneracao_bruta_brl) 
FROM `basedosdados.br_cgu_servidores_executivo_federal.remuneracao` 
WHERE ano = 2024 AND mes IN (1,2,3)
