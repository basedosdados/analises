WITH resultados AS (
  SELECT
    time_man AS time_,
    SUM(CASE
      WHEN gols_man > gols_vis THEN 3
      WHEN gols_man = gols_vis THEN 1
      ELSE 0
    END) AS pontos,
    SUM(gols_man) AS gols_feitos,
    SUM(gols_vis) AS gols_sofridos
  FROM `basedosdados.mundo_transfermarkt_competicoes.brasileirao_serie_a_atualizado`
  WHERE ano_campeonato = 2023
  GROUP BY time_man
  UNION ALL
  SELECT
    time_vis AS time,
    SUM(CASE
      WHEN gols_vis > gols_man THEN 3
      WHEN gols_vis = gols_man THEN 1
      ELSE 0
    END) AS pontos,
    SUM(gols_vis) AS gols_feitos,
    SUM(gols_man) AS gols_sofridos
  FROM `basedosdados.mundo_transfermarkt_competicoes.brasileirao_serie_a_atualizado`
  WHERE ano_campeonato = 2023
  GROUP BY time_vis
)
SELECT
  time_,
  SUM(pontos) AS pontos,
  SUM(gols_feitos) AS gols_feitos,
  SUM(gols_sofridos) AS gols_sofridos,
  SUM(gols_feitos) - SUM(gols_sofridos) AS saldo_gols
FROM resultados
GROUP BY time_
ORDER BY pontos DESC