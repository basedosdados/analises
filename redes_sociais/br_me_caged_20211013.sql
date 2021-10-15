WITH
  caged_antigo AS (
    SELECT
      t1.ano,
      t1.mes,
      t2.regiao,
      COUNT(t1.saldo_movimentacao) AS desligamento_morte,
    FROM`basedosdados.br_me_caged.microdados_antigos` t1
    JOIN`basedosdados-dev.br_bd_diretorios_brasil.uf` t2
      ON  t1.sigla_uf = t2.sigla
    WHERE t1.tipo_movimentacao_desagregado = '08'
      AND t1.saldo_movimentacao = -1
    GROUP BY 1,2,3 
  ),

  caged_novo AS (
    SELECT
      t1.ano,
      t1.mes,
      t2.regiao,
      COUNT(t1.saldo_movimentacao) AS desligamento_morte,
    FROM`basedosdados.br_me_caged.microdados_movimentacoes` t1
    JOIN`basedosdados-dev.br_bd_diretorios_brasil.uf` t2
      ON  t1.sigla_uf = t2.sigla
    WHERE t1.tipo_movimentacao = '60'
      AND t1.saldo_movimentacao = -1
    GROUP BY 1,2,3 
  ),

  desligamento_morte AS (
    SELECT *
    FROM caged_novo
    UNION ALL
    SELECT *
    FROM caged_antigo 
  ),

  populacao_regiao AS (
    SELECT
      t1.ano,
      t2.regiao,
      SUM(t1.populacao) AS populacao,
    FROM `basedosdados-dev.br_ibge_populacao.uf` t1
    JOIN `basedosdados-dev.br_bd_diretorios_brasil.uf` t2
      ON  t1.sigla_uf = t2.sigla
    GROUP BY 1, 2 
  ),

  desligamento_morte_regiao AS (
    SELECT
      FORMAT_DATE("%Y-%m",
      	PARSE_DATE("%Y-%m",
          CONCAT(
            SAFE_CAST(t1.ano AS STRING),
          	'-',
            SAFE_CAST(t1.mes AS STRING)
          )
        )
      ) date,
      t1.regiao,
      t1.desligamento_morte,
      t2.populacao,
    FROM desligamento_morte t1
    JOIN populacao_regiao t2
      ON  t1.ano = t2.ano
      AND t1.regiao = t2.regiao 
  ),

  desligamento_morte_br AS (
    SELECT
      date,
      'Brasil' AS regiao,
      SUM(desligamento_morte) AS desligamento_morte,
      SUM(populacao) AS populacao,
    FROM desligamento_morte_regiao
    GROUP BY 1, 2 
  ),

  desligamento_morte_geral AS (
    SELECT
      date,
      regiao,
      100000 * SAFE_DIVIDE(desligamento_morte,populacao) AS desligamento_morte_100k
    FROM desligamento_morte_br
    UNION ALL
    SELECT
      date,
      REPLACE(regiao,'-','_') AS regiao,
      100000 * SAFE_DIVIDE(desligamento_morte,populacao) AS desligamento_morte_100k
    FROM desligamento_morte_regiao 
  )

SELECT
  *
FROM (SELECT * FROM desligamento_morte_geral) 
  PIVOT(
    SUM(desligamento_morte_100k) 
    FOR regiao IN (
      'Brasil',
      'Centro_Oeste',
      'Nordeste',
      'Norte',
      'Sudeste',
      'Sul'
    )
  )
ORDER BY 1, 2
