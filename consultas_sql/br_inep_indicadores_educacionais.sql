#Scatter plot taxa de distorção idade-série e taxa de abandono (ensino médio)
WITH capitais AS (
SELECT municipio,id_municipio,regiao FROM `basedosdados.br_bd_diretorios_brasil.municipio`
WHERE capital_uf = 1)
SELECT t1.municipio,t1.regiao,t2.id_escola,t2.tdi_ensino_medio,t2.taxa_aband_ensino_medio
FROM capitais t1
JOIN `basedosdados.br_inep_indicadores_educacionais.escola` t2
ON t1.id_municipio = t2.id_municipio
WHERE ano = 2019
AND localizacao = 'urbana'
AND rede = 'estadual'
AND taxa_aband_ensino_medio IS NOT NULL
# A partir da base gerada foi feito um gráfico no flourish:https://public.flourish.studio/visualisation/5684964/


#Estado - ranking média de hora-aula diária em creches públicas
SELECT sigla_uf,had_educacao_infantil_creche,localizacao,rede
FROM `basedosdados.br_inep_indicadores_educacionais.uf`
WHERE ano = 2020
AND localizacao = 'urbana'
AND rede = 'publica'
ORDER BY had_educacao_infantil_creche DESC
#A partir da base gerada foi feito um gráfico no flourish: https://public.flourish.studio/visualisation/5708673/
