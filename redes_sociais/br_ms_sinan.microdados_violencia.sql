##Consulta criada por Thais Filipi

-- Consulta para calcular o total e o percentual de notificações de violência
-- por orientação sexual declarada, separando por ano

SELECT
  ano,
  
  -- Classificação do grupo com base na orientação sexual declarada
  CASE 
    WHEN orientacao_sexual_paciente IN (2, 3) THEN 'Bissexual, Gay ou Lésbica'
    WHEN orientacao_sexual_paciente = 1 THEN 'Heterossexual'
    ELSE 'Não informado ou Outro'
  END AS grupo_orientacao,
  
  -- Total de notificações desse grupo naquele ano
  COUNT(tipo_notificacao) AS total_notificacoes,
  
  -- Percentual do grupo sobre o total de notificações do mesmo ano
  ROUND(
    COUNT(tipo_notificacao) * 100.0 / 
    SUM(COUNT(tipo_notificacao)) OVER (PARTITION BY ano),
    2
  ) AS percentual_ano

FROM `basedosdados.br_ms_sinan.microdados_violencia`

-- Agrupa os dados por ano e grupo
GROUP BY ano, grupo_orientacao

-- Ordena para facilitar a leitura dos resultados
ORDER BY ano, grupo_orientacao DESC;
