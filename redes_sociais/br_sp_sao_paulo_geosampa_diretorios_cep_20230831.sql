SELECT 
  b.cep,
  b.logradouro,
  b.bairro,
  AVG(valor_construcao) as valor_construcao,
  AVG(valor_terreno) as valor_terreno
FROM basedosdados.br_sp_saopaulo_geosampa_iptu.iptu a
INNER JOIN basedosdados.br_bd_diretorios_brasil.cep b
  ON a.cep = b.cep
  WHERE ano = 2023 AND b.logradouro = 'Digite a rua'
GROUP BY cep, logradouro, bairro