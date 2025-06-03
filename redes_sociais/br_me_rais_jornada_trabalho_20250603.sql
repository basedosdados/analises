# Consultas - BD Letter de maio/2025: O fim da escala 6x1 afetaria a rotina de quantas pessoas?

# Figura 1

SELECT ano, CASE
 WHEN quantidade_horas_contratadas < 20 THEN 'Até 20 horas'
 WHEN quantidade_horas_contratadas >= 20 AND quantidade_horas_contratadas < 30 THEN 'De 20 a 30 horas'
WHEN quantidade_horas_contratadas >= 30 AND quantidade_horas_contratadas < 40 THEN 'De 30 a 40 horas'
 WHEN quantidade_horas_contratadas >= 40 AND quantidade_horas_contratadas < 44 THEN 'De 40 a 44 horas'
 WHEN quantidade_horas_contratadas >= 44 THEN 'Acima de 44 horas'
 ELSE 'Não informado'
END AS faixa_horas_contratadas,
count(vinculo_ativo_3112) as total_trabalhadores
FROM `basedosdados.br_me_rais.microdados_vinculos`
where vinculo_ativo_3112='1'
and tipo_vinculo IN ('15', '25', '70', '60', '20', '65', '75', '10', '1')
and motivo_desligamento = '0'
and tipo_vinculo != '-1'
and quantidade_horas_contratadas !=0
and quantidade_horas_contratadas != 99
and ano = 2023
group by ano, faixa_horas_contratadas
order by ano, faixa_horas_contratadas;


# Figura 2

SELECT ano, CASE
 WHEN quantidade_horas_contratadas < 20 THEN 'Até 20 horas'
 WHEN quantidade_horas_contratadas >= 20 AND quantidade_horas_contratadas < 40 THEN 'De 20 a 40 horas'
 WHEN quantidade_horas_contratadas >= 40 AND quantidade_horas_contratadas < 44 THEN 'De 40 a 44 horas'
 WHEN quantidade_horas_contratadas >= 44 THEN 'Acima de 44 horas'
 ELSE 'Não informado'
END AS faixa_horas_contratadas,
count(vinculo_ativo_3112) as total_trabalhadores
FROM `basedosdados.br_me_rais.microdados_vinculos`
where vinculo_ativo_3112='1'
and tipo_vinculo IN ('15', '25', '70', '60', '20', '65', '75', '10', '1')
and motivo_desligamento = '0'
and tipo_vinculo != '-1'
and quantidade_horas_contratadas !=0
and quantidade_horas_contratadas != 99
and ano >= 2014
group by ano, faixa_horas_contratadas
order by ano, faixa_horas_contratadas;

# Trabalhadores com cargas contraturais de trabalho superiores a 36h semanais

SELECT CASE
WHEN quantidade_horas_contratadas <= 36 THEN 'Até 36h'
WHEN quantidade_horas_contratadas > 36 THEN 'Acima de 36h'
END AS faixa_horas_contratadas,
COUNT(vinculo_ativo_3112) as total_vinculos
FROM basedosdados.br_me_rais.microdados_vinculos
WHERE ano = 2023
AND vinculo_ativo_3112='1'
AND tipo_vinculo IN ('15', '25', '70', '60', '20', '65', '75', '10', '1')
AND motivo_desligamento = '0'
AND quantidade_horas_contratadas > 0
AND quantidade_horas_contratadas <= 90
GROUP BY faixa_horas_contratadas;

