---Quantas empresas existem no Brasil hoje?
SELECT
  e.natureza_juridica,
  nj.descricao,
  COUNT(*) AS frequencia
FROM `basedosdados.br_me_cnpj.empresas` AS e
  JOIN `basedosdados.br_bd_diretorios_brasil.natureza_juridica` AS nj
  ON e.natureza_juridica = nj.id_natureza_juridica
WHERE data = "2023-09-15"
GROUP BY e.natureza_juridica, nj.descricao
ORDER BY e.natureza_juridica ASC

---Quantas empresas existem no Brasil ao longo do tempo?
SELECT
  e.data,
  e.natureza_juridica,
  nj.descricao,
  COUNT(*) AS frequencia
FROM `basedosdados.br_me_cnpj.empresas` AS e
  JOIN `basedosdados.br_bd_diretorios_brasil.natureza_juridica` AS nj
  ON e.natureza_juridica = nj.id_natureza_juridica
WHERE SUBSTR(e.natureza_juridica, 1, 1) = '2'
GROUP BY data, e.natureza_juridica, nj.descricao
ORDER BY e.natureza_juridica, e.data ASC


---Quantos sócios na média tem uma empresa, quebrado por porte?
WITH numero_socios AS (
    SELECT
        s.cnpj_basico,
        e.porte,
        COUNT(1) AS numero_socios
    FROM `basedosdados.br_me_cnpj.socios` AS s
    FULL JOIN `basedosdados.br_me_cnpj.empresas` AS e
        ON s.cnpj_basico = e.cnpj_basico
    WHERE s.data = "2023-09-15"
    GROUP BY s.cnpj_basico, e.porte
)
SELECT
    porte,
    AVG(ns.numero_socios) AS numero_socios
FROM numero_socios AS ns
GROUP BY porte
ORDER BY porte ASC


---Quantas e qual a localização das farmácias do seu estado? 
SELECT
    cnpj_basico,
    nome_fantasia,
    centroide, 
  FROM basedosdados.br_me_cnpj.estabelecimentos a
  INNER JOIN  basedosdados.br_bd_diretorios_brasil.cep b
  ON a.cep = b.cep
  WHERE cnae_fiscal_principal = '4771701'  #Insira o Cnae que você gostaria
    AND situacao_cadastral ='02' #Situação Ativa
	AND data = '2023-09-15' #insira uma data no formato yyyy-mm-dd
  AND a.sigla_uf = 'ES' #Insira uma UF de seu interesse
 
---Qual a atratividade dos setores censitários da minha UF em instalar
---uma farmácia para pessoas com 65 anos ou mais?
WITH pop65 AS (
  SELECT 
    id_setor_censitario,
    v099 + v100 + v101 + v102 + v103 + v104 + v105 + v106 + v107 + v108 + v109 +
    v110 + v111 + v112 + v113 + v114 + v115 + v116 + v117 + v118 + v119 + v120 +
    v121 + v122 + v123 + v124 + v125 + v126 + v127 + v128 + v129 + v130 +
    v131 + v132 + v133 + v134 AS mais65
  FROM basedosdados.br_ibge_censo_demografico.setor_censitario_idade_total_2010
),
setor AS (
  SELECT 
    pop65.id_setor_censitario,
    mais65,
    geometria 
  FROM pop65
  INNER JOIN basedosdados.br_geobr_mapas.setor_censitario_2010 c
  ON pop65.id_setor_censitario = c.id_setor_censitario
),
cnpj AS (
  SELECT
    cnpj_basico,
    nome_fantasia,
    centroide, -- Use o centroide da base de CEP
  FROM basedosdados.br_me_cnpj.estabelecimentos a
  INNER JOIN  basedosdados.br_bd_diretorios_brasil.cep b
  ON a.cep = b.cep
  WHERE cnae_fiscal_principal = '4771701' 
    AND situacao_cadastral ='02'
	AND data = '2023-09-15'
  #AND a.sigla_uf = 'ES'
    ),
setor_farmacias AS (
  SELECT 
    setor.id_setor_censitario,
    setor.mais65,
    COUNT(cnpj.cnpj_basico) as num_farmacias
  FROM setor
  LEFT JOIN cnpj
  ON ST_CONTAINS(setor.geometria, cnpj.centroide) -- Use ST_CONTAINS com o centroide da farmácia
  GROUP BY setor.id_setor_censitario, setor.mais65
),
atratividade AS (
  SELECT 
    setor_farmacias.id_setor_censitario,
    setor_farmacias.mais65,
    setor_farmacias.num_farmacias,
    setor.geometria,
    CASE 
      WHEN setor_farmacias.num_farmacias = 0 THEN NULL
      ELSE setor.mais65 / NULLIF(setor_farmacias.num_farmacias, 0)
    END as atratividade
  FROM setor_farmacias
  JOIN setor
  ON setor_farmacias.id_setor_censitario = setor.id_setor_censitario
)
SELECT * FROM atratividade
WHERE num_farmacias > 0

---Localização de igrejas evangélicas no Brasil
SELECT 
  cnpj_basico, 
  nome_fantasia,
  a.id_municipio, 
  b.cep,
  a.sigla_uf,
  ST_CENTROID_AGG(centroide) as centroide  
FROM basedosdados.br_me_cnpj.estabelecimentos a
INNER JOIN basedosdados.br_bd_diretorios_brasil.cep b
  ON a.cep = b.cep
WHERE cnae_fiscal_principal = '9491000'
  AND (nome_fantasia LIKE '%PENTECOSTAL%' OR nome_fantasia LIKE '%NEOPENTECOSTAL%')
GROUP BY cnpj_basico, nome_fantasia, a.id_municipio, b.cep, a.sigla_uf
