##### Qual UF teve a maior quantidade de furto de veículos de 2016 a 2021?
SELECT ano, sigla_uf, quantidade_roubo_furto_veiculos
 FROM `basedosdados.br_fbsp_absp.municipio`
 GROUP BY ano, sigla_uf, quantidade_roubo_furto_veiculos
 ORDER BY ano DESC, quantidade_roubo_furto_veiculos DESC