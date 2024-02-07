# O valor da produção da extração vegetal cresceu no Brasil nas últimas três décadas? 

SELECT 
  ano,
  ROUND(SUM(valor) * 1000, 2) AS valor_total_producao
FROM 
  `basedosdados.br_ibge_pevs.producao_extracao_vegetal` 
WHERE 
  ano IN (1992, 2002, 2012, 2022)
GROUP BY
  ano
ORDER BY 
  ano
