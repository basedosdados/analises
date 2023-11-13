-- Quantos focos de queimadas o seu municipio teve ao longo do tempo? 
SELECT 
  ano,
  bioma,
  nome,
  COUNT(id_foco) AS qtde_focos
FROM basedosdados.br_inpe_queimadas.microdados a  
INNER JOIN basedosdados.br_bd_diretorios_brasil.municipio b
ON a.id_municipio = b.id_municipio
WHERE nome = 'Seu municipio'
GROUP BY ano, nome, bioma
ORDER BY ano DESC 