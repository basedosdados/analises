SELECT 
    ano, 
    mes,
    sum(consumo) as consumo
FROM 
`basedosdados-dev.br_mme_consumo_energia_eletrica.uf` 
WHERE tipo_consumo = "Residencial" and ano >= 2019 
GROUP BY ano, mes
ORDER BY ano asc