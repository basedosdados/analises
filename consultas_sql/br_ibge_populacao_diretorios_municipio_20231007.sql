#Para o seu município de interesse
WITH populacao AS (
  SELECT
    a.sigla_uf,
    nome,
    MAX(CASE WHEN ano = 2010 THEN populacao END) AS populacao_2010,
    MAX(CASE WHEN ano = 2022 THEN populacao END) AS populacao_2022
  FROM
    basedosdados.br_ibge_populacao.municipio a
    INNER JOIN basedosdados.br_bd_diretorios_brasil.municipio b 
      ON a.id_municipio = b.id_municipio
  WHERE
    nome = 'Seu município' AND (ano = 2010 OR ano = 2022)
  GROUP BY
    a.sigla_uf, nome
)
SELECT * FROM populacao;

#Para todos os municipios do País:
WITH populacao AS (
  SELECT
    a.sigla_uf,
    nome,
    MAX(CASE WHEN ano = 2010 THEN populacao END) AS populacao_2010,
    MAX(CASE WHEN ano = 2022 THEN populacao END) AS populacao_2022
  FROM
    basedosdados.br_ibge_populacao.municipio a
    INNER JOIN basedosdados.br_bd_diretorios_brasil.municipio b 
      ON a.id_municipio = b.id_municipio
  WHERE
    ano = 2010 OR ano = 2022
  GROUP BY
    a.sigla_uf, nome
)
SELECT * FROM populacao;

