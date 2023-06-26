SELECT instituicao, nome_agencia,fone, logradouro, cnpj, centroide, latitude, longitude,
FROM basedosdados.br_bcb_agencia.agencia a 
INNER JOIN basedosdados.br_bd_diretorios_brasil.cep b
ON a.cep = b.cep
where ano = 'Insira o ano' AND mes = 'Insira o Mês' AND cidade = 'Insira a Cidade'