
## Qual o Município com menor população no Brasil?
SELECT
  m.nome AS nome_municipio,
  c.*
FROM
  `basedosdados.br_ibge_censo_2022.area_territorial_densidade_demografica_municipio` AS c
JOIN
  `basedosdados.br_bd_diretorios_brasil.municipio` AS m
ON
  c.id_municipio = m.id_municipio
ORDER BY
  c.populacao_residente 
LIMIT 1;

## Qual o Município com mario população no Brasil?

SELECT
  m.nome AS nome_municipio,
  c.*
FROM
  `basedosdados.br_ibge_censo_2022.area_territorial_densidade_demografica_municipio` AS c
JOIN
  `basedosdados.br_bd_diretorios_brasil.municipio` AS m
ON
  c.id_municipio = m.id_municipio
ORDER BY
  c.populacao_residente DESC
LIMIT 1;

## Maior Área de Unidade Territorial
SELECT
  m.nome AS nome_municipio,
  c.*
FROM
  `basedosdados.br_ibge_censo_2022.area_territorial_densidade_demografica_municipio` AS c
JOIN
  `basedosdados.br_bd_diretorios_brasil.municipio` AS m
ON
  c.id_municipio = m.id_municipio
ORDER BY
  c.area_unidade_territorial DESC
LIMIT 1;
