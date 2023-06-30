WITH tabela_geral AS (
  SELECT
    ano_campeonato,
    time_man,
    time_vis,
    gols_man,
    gols_vis,
    chutes_man,
    chutes_vis
  FROM `basedosdados.mundo_transfermarkt_competicoes.brasileirao_serie_a`
WHERE time_man IN ('Flamengo','Palmeiras') OR time_vis IN ('Flamengo','Palmeiras'))
SELECT
  ano_campeonato,
  (SUM(CASE WHEN time_man = 'Flamengo' THEN gols_man ELSE 0 END) / NULLIF(SUM(CASE WHEN time_man = 'Flamengo' THEN chutes_man ELSE 0 END), 0)) * 100 AS taxa_aproveitamento_mandante_flamengo,
  (SUM(CASE WHEN time_vis = 'Flamengo' THEN gols_vis ELSE 0 END) / NULLIF(SUM(CASE WHEN time_vis = 'Flamengo' THEN chutes_vis ELSE 0 END), 0)) * 100 AS taxa_aproveitamento_visitante_flamengo,
  (SUM(CASE WHEN time_man = 'Palmeiras' THEN gols_man ELSE 0 END) / NULLIF(SUM(CASE WHEN time_man = 'Palmeiras' THEN chutes_man ELSE 0 END), 0)) * 100 AS taxa_aproveitamento_mandante_palmeiras,
  (SUM(CASE WHEN time_vis = 'Palmeiras' THEN gols_vis ELSE 0 END) / NULLIF(SUM(CASE WHEN time_vis = 'Palmeiras' THEN chutes_vis ELSE 0 END), 0)) * 100 AS taxa_aproveitamento_visitante_palmeiras
FROM tabela_geral
WHERE ano_campeonato >= 2020
GROUP BY ano_campeonato
ORDER BY ano_campeonato ASC