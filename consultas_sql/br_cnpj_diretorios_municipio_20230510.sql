SELECT COUNT(DISTINCT cnpj) AS quantidade_cnpj, data 
FROM `basedosdados.br_me_cnpj.estabelecimentos` a
INNER JOIN `basedosdados.br_bd_diretorios_brasil.municipio` b
ON a.id_municipio = b.id_municipio 
WHERE a.sigla_uf ='Sua sigla UF' AND nome = 'Seu Município'
GROUP BY data