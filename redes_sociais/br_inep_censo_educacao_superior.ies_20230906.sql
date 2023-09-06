###Diferença por Genero
WITH sexo AS (
SELECT 
  ano,
  COUNT(DISTINCT(id_ies)) as qtde_ies,
  SUM(quantidade_docentes_exercicio_feminino) as feminino,
  SUM(quantidade_docentes_exercicio_masculino) as masculino
FROM `basedosdados.br_inep_censo_educacao_superior.ies` 
GROUP BY ano)
SELECT ano,
ROUND(
    ((SUM(feminino) - SUM(masculino)) / SUM(masculino)) * 100, 
    2
  ) as diferenca_porcentagem_sexo
FROM sexo
GROUP BY ano
ORDER BY ano DESC

### Diferença por raça/cor
WITH cor AS (
SELECT 
  ano,
  COUNT(DISTINCT(id_ies)) as qtde_ies,
  SUM(quantidade_docentes_exercicio_branca) as branca,
  SUM(quantidade_docentes_exercicio_preta) as preta,
  SUM(quantidade_docentes_exercicio_parda) as parda,
  SUM(quantidade_docentes_exercicio_amarela) as amarela,
  SUM(quantidade_docentes_exercicio_indigena) as indigena,
FROM `basedosdados.br_inep_censo_educacao_superior.ies` 
GROUP BY ano)
SELECT 
  ano,
  ROUND((branca / NULLIF(branca + preta + parda + amarela + indigena, 0)) * 100, 2) as porcentagem_branca,
  ROUND((preta / NULLIF(branca + preta + parda + amarela + indigena, 0)) * 100, 2) as porcentagem_preta,
  ROUND((parda / NULLIF(branca + preta + parda + amarela + indigena, 0)) * 100, 2) as porcentagem_parda,
  ROUND((amarela / NULLIF(branca + preta + parda + amarela + indigena, 0)) * 100, 2) as porcentagem_amarela,
  ROUND((indigena / NULLIF(branca + preta + parda + amarela + indigena, 0)) * 100, 2) as porcentagem_indigena
FROM cor
ORDER BY ano DESC;

### Diferença por Idade
WITH idade AS (
SELECT 
  ano,
  SUM(quantidade_docentes_exercicio_0_29) as docentes0a29,
  SUM(quantidade_docentes_exercicio_30_34) as docentes30a34,
  SUM(quantidade_docentes_exercicio_35_39) as docentes35a39,
  SUM(quantidade_docentes_exercicio_40_44) as docentes40a44,
  SUM(quantidade_docentes_exercicio_45_49) as docentes45a49,
  SUM(quantidade_docentes_exercicio_50_54) as docentes50a54,
  SUM(quantidade_docentes_exercicio_55_59) as docentes55a59,
  SUM(quantidade_docentes_exercicio_60_mais) as docentes60mais
FROM `basedosdados.br_inep_censo_educacao_superior.ies` 
  GROUP BY ano)
SELECT
  ano,
  ROUND((docentes0a29 / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_0a29,
  ROUND((docentes30a34 / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_30a34,
  ROUND((docentes35a39 / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_35a39,
  ROUND((docentes40a44 / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_40a44,
  ROUND((docentes45a49 / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_45a49,
  ROUND((docentes50a54 / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_50a54,
  ROUND((docentes55a59 / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_55a59,
  ROUND((docentes60mais / NULLIF(idade.docentes0a29+idade.docentes30a34+idade.docentes35a39+idade.docentes40a44+idade.docentes45a49+idade.docentes50a54+idade.docentes55a59+idade.docentes60mais, 0)) * 100, 2) as porcentagem_60mais
FROM idade
ORDER BY ano DESC;