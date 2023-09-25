WITH
  tabela_geral AS (
  SELECT
    ano_campeonato,
    time_mandante,
    time_visitante,
    gols_mandante,
    gols_visitante,
    CASE
      WHEN (gols_mandante > gols_visitante) AND penalti = 0 THEN 3
      WHEN (gols_mandante = gols_visitante) AND penalti = 0 THEN 1
      WHEN (gols_mandante < gols_visitante) AND penalti = 0 THEN 0
    END AS pontos_mandante,
    CASE
      WHEN (gols_visitante > gols_mandante) AND penalti = 0 THEN 3
      WHEN (gols_visitante = gols_mandante) AND penalti = 0 THEN 1
      WHEN (gols_visitante < gols_mandante) AND penalti = 0 THEN 0
    END AS pontos_visitante
  FROM
    `basedosdados.mundo_transfermarkt_competicoes.copa_brasil`
  WHERE
    time_mandante IN ('Flamengo', 'São Paulo')
    OR time_visitante IN ('Flamengo', 'São Paulo')
)
SELECT
  ano_campeonato,
  (SUM(CASE
        WHEN time_mandante = 'São Paulo' THEN pontos_mandante
        ELSE 0
      END) / NULLIF(SUM(CASE
                          WHEN time_mandante = 'São Paulo' THEN 3
                          ELSE 0
                        END), 0)) * 100 AS taxa_aproveitamento_mandante_sao_paulo_2_tempos,
  (SUM(CASE
        WHEN time_visitante = 'Flamengo' THEN pontos_visitante
        ELSE 0
      END) / NULLIF(SUM(CASE
                          WHEN time_visitante = 'Flamengo' THEN 3
                          ELSE 0
                        END), 0)) * 100 AS taxa_aproveitamento_visitante_flamengo_2_tempos,
  AVG(CASE
        WHEN time_visitante = 'Flamengo' THEN gols_visitante
        ELSE NULL
      END) AS media_gols_visitante_flamengo,
  AVG(CASE
        WHEN time_mandante = 'São Paulo' THEN gols_mandante
        ELSE NULL
      END) AS media_gols_mandante_sao_paulo,
  AVG(CASE
        WHEN time_visitante = 'Flamengo' THEN gols_visitante - gols_mandante
        ELSE NULL
      END) AS media_saldo_gols_flamengo_visitante,
  AVG(CASE
        WHEN time_mandante = 'São Paulo' THEN gols_mandante - gols_visitante
        ELSE NULL
      END) AS media_saldo_gols_sao_paulo_mandante,
FROM tabela_geral
WHERE ano_campeonato >= 2020
GROUP BY ano_campeonato
ORDER BY ano_campeonato ASC