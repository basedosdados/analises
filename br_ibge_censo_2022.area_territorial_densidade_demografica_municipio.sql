# Código para conferir área territorial e densidade demográfica (CENSO 2022) usando apenas o nome da cidade 

SELECT
  m.nome AS nome_municipio,
  c.*
FROM
  `basedosdados.br_ibge_censo_2022.area_territorial_densidade_demografica_municipio` AS c
JOIN
  `basedosdados.br_bd_diretorios_brasil.municipio` AS m
ON
  c.id_municipio = m.id_municipio
WHERE
  m.nome = 'Adicione o nome da cidade brasileira que você quiser'
LIMIT 1;
