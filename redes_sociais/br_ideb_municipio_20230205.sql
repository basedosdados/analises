SELECT ano, rede, ensino, anos_escolares, taxa_aprovacao
FROM `basedosdados.br_inep_ideb.municipio` a
INNER JOIN `basedosdados.br_bd_diretorios_brasil.municipio`b
ON a.id_municipio = b.id_municipio
WHERE nome = 'Seu Municipio'
GROUP BY ano, rede, ensino, anos_escolares, taxa_aprovacao
ORDER BY ano ASC