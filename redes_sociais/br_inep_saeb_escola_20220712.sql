WITH saeb_escola AS 
(SELECT 
ano, 
id_escola,
sigla_uf,
media_9_ef_lp, 
media_9_ef_mt,
CASE
  WHEN (media_9_ef_lp < 200) THEN 1
  ELSE 0
  END AS insuficiente_LP_9,
CASE
    WHEN (media_9_ef_mt < 225) THEN 1
    ELSE 0
    END AS insuficiente_MT_9,

CASE
    WHEN (media_9_ef_lp >= 200 AND media_9_ef_lp < 275) THEN 1
    ELSE 0
    END AS basico_LP_9,
CASE
    WHEN (media_9_ef_mt >= 225 AND media_9_ef_mt < 300) THEN 1
    ELSE 0
    END AS basico_MT_9,

CASE
    WHEN (media_9_ef_lp >= 275 AND media_9_ef_lp < 325) THEN 1
    ELSE 0
    END AS proficiente_LP_9,
CASE
    WHEN (media_9_ef_mt >= 300 AND media_9_ef_mt < 350) THEN 1
    ELSE 0
    END AS proficiente_MT_9,

CASE
    WHEN (media_9_ef_lp >= 325) THEN 1
    ELSE 0
    END AS avancado_LP_9,
CASE
    WHEN (media_9_ef_mt >= 350) THEN 1
    ELSE 0
    END AS avancado_MT_9,

CASE
    WHEN (media_9_ef_lp >= 275) THEN 1
    ELSE 0
    END AS adequado_LP_9,
CASE
    WHEN (media_9_ef_mt >= 300) THEN 1
    ELSE 0
    END AS adequado_MT_9,

  FROM basedosdados-dev.br_inep_saeb.escola_2007_2019
  WHERE rede IN ('1', '2', '3') AND (media_9_ef_lp IS NOT NULL 
  OR media_9_ef_mt IS NOT NULL) AND ano>=2011)

SELECT br.ano,percentual_adequado_MT_9_ce,
ROUND(100 * AVG(br.adequado_MT_9),2) AS percentual_adequado_MT_9_br
FROM (
SELECT
  ano,
  ROUND(100 * AVG(adequado_MT_9),2) as percentual_adequado_MT_9_ce
  FROM saeb_escola
  WHERE sigla_uf='CE'
  GROUP BY ano) AS ce INNER JOIN saeb_escola AS br
  ON ce.ano=br.ano
  GROUP BY br.ano, percentual_adequado_MT_9_ce
  ORDER BY ano