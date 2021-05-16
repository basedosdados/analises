     #PIB das capitais do país em 2018
WITH pib_2018 AS (
SELECT PIB,id_municipio,ano
FROM `basedosdados.br_ibge_pib.municipios` 
WHERE ano = 2018)
SELECT t1.PIB,t2.municipio
FROM pib_2018 t1
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` t2
ON t1.id_municipio = t2.id_municipio
WHERE capital_uf = 1

      #IDEB das capitais em 2019
WITH capitais AS (
SELECT municipio,id_municipio,regiao FROM `basedosdados.br_bd_diretorios_brasil.municipio`
WHERE capital_uf = 1)
SELECT t1.municipio,t1.regiao,t2.ideb
FROM capitais t1
JOIN `basedosdados.br_inep_ideb.municipio` t2
ON t1.id_municipio = t2.id_municipio
WHERE ano = 2019
AND rede = 'publica'
AND ensino = 'medio'

     #População das capitais em 2018
WITH pop_2018 AS (
SELECT *
FROM `basedosdados.br_ibge_populacao.municipios` 
WHERE ano = 2018)
SELECT t1.populacao,t2.municipio
FROM pop_2018 t1
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` t2
ON t1.id_municipio = t2.id_municipio
WHERE capital_uf = 1