SELECT id_estabelecimento_cnes, tipo_gestao, tipo_natureza_administrativa,
a.cep, latitude, longitude, logradouro, centroide
FROM `basedosdados.br_ms_cnes.estabelecimento` a 
INNER JOIN `basedosdados.br_bd_diretorios_brasil.cep` b
ON a.cep = b.cep
WHERE cidade = 'Sua Cidade' AND ano = 'Digite o Ano' AND mes = 'Digite o Mês