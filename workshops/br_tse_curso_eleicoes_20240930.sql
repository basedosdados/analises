# 1- Qual a idade média dos candidatos?

## Consulta geral
### Aqui selecionamos a sigla das UFs, ID e nome dos municípios e a idade média arredondada dos candidatos

SELECT cand.sigla_uf, cand.id_municipio, mun.nome, cargo, ROUND(AVG(idade),1) AS media_idade 
FROM `basedosdados.br_tse_eleicoes.candidatos` AS cand
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS mun
ON cand.id_municipio = mun.id_municipio
WHERE ano = 2024
GROUP BY cand.sigla_uf, cand.id_municipio, mun.nome, cargo
ORDER BY sigla_uf, cand.id_municipio;


# 2 - Quantos são os candidatos por raça/cor?

## Consulta geral
### Aqui selecionamos a sigla das UFs, ID e nome dos municípios e a contagem por raça/cor dos candidatos

SELECT cand.sigla_uf, cand.id_municipio, mun.nome, raca, count(raca) AS total_raca_cor 
FROM `basedosdados.br_tse_eleicoes.candidatos` AS cand
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS mun
ON cand.id_municipio = mun.id_municipio
WHERE ano = 2024 AND cargo = "vereador" # ou prefeito
GROUP BY cand.sigla_uf, cand.id_municipio, mun.nome, raca
ORDER BY sigla_uf, cand.id_municipio;

## Consulta por sexo e raça/cor

SELECT cand.sigla_uf, cand.id_municipio, mun.nome, genero, raca, count(raca) AS total_sexo_raca 
FROM `basedosdados.br_tse_eleicoes.candidatos` AS cand
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS mun
ON cand.id_municipio = mun.id_municipio
WHERE ano = 2024 AND cargo = "vereador" # ou prefeito
GROUP BY cand.sigla_uf, cand.id_municipio, mun.nome, genero, raca
ORDER BY sigla_uf, cand.id_municipio;


# 3 - Qual o patrimônio dos candidatos a prefeitura de Manaus?

## Total de bens declarados

SELECT cand.nome, ROUND(SUM(valor_item),1) AS total_bens
FROM `basedosdados.br_tse_eleicoes.bens_candidato` AS bens
INNER JOIN `basedosdados.br_tse_eleicoes.candidatos` AS cand
ON bens.sequencial_candidato = cand.sequencial
WHERE bens.ano = 2024 AND id_municipio = "1302603" AND cargo = "prefeito"
GROUP BY nome
ORDER BY nome, total_bens;

## Bens declarados por candidato por tipo de item

SELECT cand.nome, tipo_item, descricao_item, SUM(valor_item) AS total_bens
FROM `basedosdados.br_tse_eleicoes.bens_candidato` bens
JOIN `basedosdados.br_tse_eleicoes.candidatos` cand
ON bens.sequencial_candidato = cand.sequencial
WHERE bens.ano = 2024 AND id_municipio = "1302603" AND cargo = "prefeito"
GROUP BY nome, tipo_item, descricao_item
ORDER BY nome;


## Efeitos da LGPD (Lei Geral de Proteção de Dados Pessoais) sobre a declaração de bens

SELECT bc.ano,c.nome, bc.tipo_item, bc.descricao_item, SUM(bc.valor_item) AS total_item
FROM `basedosdados.br_tse_eleicoes.bens_candidato` bc
JOIN `basedosdados.br_tse_eleicoes.candidatos` c 
  ON bc.sequencial_candidato = c.sequencial
WHERE id_municipio = "1302603" AND (bc.ano = 2020 OR bc.ano = 2024) AND c.cargo = "prefeito" AND c.nome = "David Antonio Abisai Pereira De Almeida"
GROUP BY bc.ano, c.nome, bc.tipo_item, bc.descricao_item
ORDER BY bc.ano;


### Como filtrar por município sem usar o id_municipio
SELECT bc.ano, c.nome_urna, bc.tipo_item, bc.descricao_item, bc.valor_item
FROM `basedosdados.br_tse_eleicoes.bens_candidato` bc
JOIN `basedosdados.br_tse_eleicoes.candidatos` c 
  ON bc.sequencial_candidato = c.sequencial
LEFT JOIN (SELECT DISTINCT id_municipio,nome FROM `basedosdados.br_bd_diretorios_brasil.municipio`) db
  ON c.id_municipio = db.id_municipio
WHERE (bc.ano = 2020 OR bc.ano = 2024) AND db.nome="Manaus" AND c.cargo = "prefeito" AND nome_urna="David Almeida";

#### Apoio para filtro de município: https://www.ibge.gov.br/explica/codigos-dos-municipios.php

# 4- A proporção de mulheres atendem as cotas? (mínimo de 30% por sexo)

## A unidade de observação para checar o cumprimento da legislação são os partidos ou federações.
## Contudo, podemos checar como os municípios estão atendendo esses critérios como um todo.
## Avançar nas unidades de análise, como por estado ou o país também pode ser interessante, 
## mas ficam ainda mais distantes das realidades aonde as eleições vão acontecer este ano.

## Mesmo que não exigida pela legislação também podemos checar a proporção de candidaturas à prefeitura por sexo.
## Nesse caso ver como está a situação nas UFs pode ter um valor analítico maior

### Consulta geral
#### Aqui selecionamos a sigla das UFs, o ID e nome dos municípios, e a contagem por sexo dos candidatos.
#### A partir disso podemos calcular a proporção e percentual das candidaturas por sexo em cada município

SELECT cand.sigla_uf, cand.id_municipio, mun.nome, genero, count(genero) AS total_genero 
FROM `basedosdados.br_tse_eleicoes.candidatos` AS cand
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS mun
ON cand.id_municipio = mun.id_municipio
WHERE ano = 2024 AND cargo = "prefeito" # ou prefeito
GROUP BY cand.sigla_uf, cand.id_municipio, mun.nome, genero
ORDER BY sigla_uf, cand.id_municipio;

### Consulta com as proporções por sexo
#### Aqui selecionamos a sigla das UFs, o ID e nome dos municípios, e a contagem por sexo dos candidatos.
#### Com a ajuda de uma subconsulta calculamos aqui mesmo a proporção arredondada das candidaturas por sexo

SELECT 
cand.sigla_uf, 
cand.id_municipio, 
mun.nome, 
genero, 
COUNT(genero) AS total_sexo,
ROUND(COUNT(genero) / total.total_candidatos, 2) AS proporcao_sexo
FROM `basedosdados.br_tse_eleicoes.candidatos` AS cand
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS mun
ON cand.id_municipio = mun.id_municipio
JOIN 
(SELECT id_municipio, count(*) AS total_candidatos
FROM `basedosdados.br_tse_eleicoes.candidatos`
WHERE ano = 2024 AND cargo = "vereador" # ou prefeito
GROUP BY id_municipio
) AS total
ON cand.id_municipio = total.id_municipio
WHERE ano = 2024 AND cargo = "vereador" # ou prefeito
GROUP BY 
cand.sigla_uf, 
cand.id_municipio, 
mun.nome, 
genero, 
total.total_candidatos
ORDER BY 
sigla_uf, 
cand.id_municipio; 




