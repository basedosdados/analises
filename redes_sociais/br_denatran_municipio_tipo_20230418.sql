SELECT automovel, motocicleta, nome, mes
FROM basedosdados.br_denatran_frota.municipio_tipo a 
INNER JOIN br_bd_diretorios_brasil.municipio b
ON a.id_municipio = b.id_municipio
WHERE nome = 'Seu Município' AND ano ='Digite o Ano' AND mes = 'Digite o mês'