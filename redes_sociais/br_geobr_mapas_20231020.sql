--- Polígonos dos territórios indígenas do Brasil
SELECT * FROM `basedosdados.br_geobr_mapas.terra_indigena` 

--- Latitude e longitude de todas as escolas brasileiras de 2020
SELECT * FROM `basedosdados.br_geobr_mapas.escola`
WHERE sigla_uf = 'AC' 

--- Latitude e Longitude dos estabelecimentos de Saúde de 2015
SELECT * FROM `basedosdados.br_geobr_mapas.estabelecimentos_saude` 
WHERE sigla_uf = 'AC'
