WITH
m AS (SELECT ano, sigla_uf,
SUM(valor_fob_dolar) AS importacao
FROM basedosdados-dev.br_me_comex_stat.municipio_importacao AS t
WHERE ano = 2020
GROUP BY ano, sigla_uf
ORDER BY importacao DESC)
SELECT t1.ano, t1.sigla_uf, importacao,
SUM(valor_fob_dolar) AS exportacao
FROM m AS t1
JOIN basedosdados-dev.br_me_comex_stat.municipio_exportacao AS t2
ON t1.ano = t2.ano
AND t1.sigla_uf = t2.sigla_uf
GROUP BY ano, sigla_uf, importacao
ORDER BY importacao DESC

Exportação:
https://public.flourish.studio/visualisation/5654577/

Importação:
https://public.flourish.studio/visualisation/5642412/
