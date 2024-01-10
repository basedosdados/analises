SELECT
  v.cnae_2_subclasse AS CNAE,
  SUM(CASE WHEN v.ano = 2017 THEN v.quantidade_vinculos_ativos ELSE 0 END) AS Empregos_2018,
  SUM(CASE WHEN v.ano = 2018 THEN v.quantidade_vinculos_ativos ELSE 0 END) AS Empregos_2019,
  SUM(CASE WHEN v.ano = 2019 THEN v.quantidade_vinculos_ativos ELSE 0 END) AS Empregos_2020,
  SUM(CASE WHEN v.ano = 2020 THEN v.quantidade_vinculos_ativos ELSE 0 END) AS Empregos_2021,
  SUM(CASE WHEN v.ano = 2021 THEN v.quantidade_vinculos_ativos ELSE 0 END) AS Empregos_2022,


  v.sigla_uf AS UF,
  v.id_municipio
FROM
  basedosdados.br_me_rais.microdados_estabelecimentos v
WHERE
  v.cnae_2_subclasse IS NOT NULL
  AND v.sigla_uf = 'RJ'
  AND v.id_municipio = '3304557'
  AND v.ano BETWEEN 2012 AND 2022
  AND v.quantidade_vinculos_ativos IS NOT NULL
GROUP BY
  v.cnae_2_subclasse, v.sigla_uf, v.id_municipio
ORDER BY
  CNAE DESC;
