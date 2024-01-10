##Pergunta: Tivemos mais contratos contratos pré ou pós-pagos de telefonia móvel no Brasil em 2023?

SELECT
  modalidade,
  COUNT(*) AS quantidade_contratos,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS proporcao
FROM
  `basedosdados.br_anatel_telefonia_movel.microdados`
WHERE
  ano = 2023
GROUP BY
  modalidade;

##Pergunta: Quais empresas tiveram mais contratos de telefonía móvel no Brasil em 2023?

SELECT
  empresa,
  COUNT(*) AS quantidade_contratos,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER(), 3) AS proporcao
FROM
    `basedosdados.br_anatel_telefonia_movel.microdados`
WHERE
  ano = 2023
GROUP BY
  empresa
ORDER BY
  quantidade_contratos DESC;

##Pergunta: Qual tipo de sinal foi predominante nos contratos de telefonia móvel no Brasil em 2023? 

SELECT
  sinal,
  COUNT(*) AS quantidade_sinal,
  ROUND(COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS proporcao
FROM
  `basedosdados.br_anatel_telefonia_movel.microdados`
WHERE
  ano = 2023
GROUP BY
  sinal;

