# Qual foi a remuneração média de servidores do executivo federal no primeiro semestre de 2024?
SELECT ROUND (AVG (remuneracao_bruta_brl)) as media_servidores 
FROM `basedosdados.br_cgu_servidores_executivo_federal.remuneracao` 
WHERE ano = 2024 AND mes IN (1,2,3)

# Qual foi a remuneração máxima de servidores do executivo federal no primeiro semestre de 2024?
SELECT MAX(remuneracao_bruta_brl) 
FROM `basedosdados.br_cgu_servidores_executivo_federal.remuneracao` 
WHERE ano = 2024 AND mes IN (1,2,3)
